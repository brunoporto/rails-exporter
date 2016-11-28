require 'builder'
require 'spreadsheet'

module RailsExporter
  module Exporter

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def export_to_csv(records, context=:default)
        CSV.generate({:col_sep => ';', :force_quotes => true}) do |csv|
          # HEADER
          csv << get_columns(context).map do |attr|
            attr_name(attr)
          end
          # BODY
          records.each do |record|
            csv << get_values(record, context)
          end
        end
      end

      def export_to_xml(records, context=:default)
        #File XML
        xml = Builder::XmlMarkup.new(:indent => 2)
        #Format
        xml.instruct! :xml, :encoding => "UTF-8"
        xml.records do
          #Records
          records.each do |record|
            get_values = get_values(record, context)
            xml.record do |r|
              i = 0
              get_columns(context).map do |attr|
                attr = attr.keys.first if attr.is_a?(Hash)
                xml.tag!(attr, get_values[i], {title: attr_name(attr)})
                i+=1
              end
            end
          end
        end
      end

      def export_to_xls(records, context=:default)
        #FILE
        file_contents = StringIO.new
        #CHARSET
        Spreadsheet.client_encoding = 'UTF-8'
        #NEW document/spreadsheet
        document = Spreadsheet::Workbook.new
        spreadsheet = document.create_worksheet
        spreadsheet.name = I18n.t(:spreadsheet_name, default: ['Spreadsheet'], scope: [:exporters])
        #HEADER FORMAT
        spreadsheet.row(0).default_format = Spreadsheet::Format.new :weight => :bold
        #HEADER
        get_columns(context).each_with_index do |attr, i|
          attr = attr.keys.first if attr.is_a?(Hash)
          spreadsheet.row(0).insert i, (self.human_attribute_name(attr) || attr)
        end
        #ROWS
        records.each_with_index do |record, i|
          values = get_values(record, context)
          spreadsheet.row(i+1).push(*values)
        end
        #SAVE spreadsheet
        document.write file_contents
        #RETURN STRING
        file_contents.string.force_encoding('binary')
      end

      private
      def get_columns(context)
        self.send(:columns, context) || []
      end

      def attr_name(attr)
        attr[:label] || attr[:column]
      end

      def get_values(record, context)
        get_columns(context).map do |attribute|
          if attribute[:block].is_a?(Proc)
            value = attribute[:block].call(record)
            value.to_s
          else
            value = (record.send(attribute[:column]) rescue '')
            normalize_value(value, attribute[:type])
          end
        end
      end

      def normalize_value(value, type=nil)
        type = type.present? ? type.to_sym : :unknown
        if type==:currency
          ActionController::Base.helpers.number_to_currency(value)
        elsif type==:boolean
          (value==true or value=='true' or value=='1') ? 'S' : 'N'
        elsif type==:date
          (I18n.l(value, format: '%d/%m/%Y') rescue value).to_s
        elsif type==:datetime
          (I18n.l(value, format: '%d/%m/%Y %H:%i:%s') rescue value).to_s
        else
          (I18n.l(value) rescue value)
        end
      end

    end

  end
end