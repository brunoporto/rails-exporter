require 'rails_exporter/exporter'

module RailsExporter
  class Base
    include RailsExporter::Exporter

    class_attribute :exporters

    class << self
      def file_types
        [:csv, :xls, :xml]
      end

      # def method_missing(m, *args, &block)
      #   if m =~ /_url|_path/
      #     Rails.application.routes.url_helpers.send(m, args)
      #   end
      # end

      def exporter(name=:default, &block)
        (self.exporters ||= {})[name] ||= []
        @exporter_name = name
        block.call if block_given?
        self.exporters[name]
      end

      def column(attr, &block)
        if attr.is_a?(Hash)
          attribute = attr.keys.first.to_s.to_sym
          type = attr.values.first.to_s.to_sym
        else
          attribute = attr.to_sym
          type = :string
        end

        label = I18n.t(attribute, default: [attribute.to_s.humanize], scope: [:exporters, @exporter_name])
        self.exporters[@exporter_name] << {column: attribute, label: label, type: normalize_type(type), block: block}
      end

      def columns(exporter_name=:default)
        self.exporters[exporter_name].map do |attribute|
          attribute.slice(:column, :label, :type)
        end
      end

      private
      def normalize_type(type)
        if [:currency, :boolean, :date, :datetime, :string].include?(type.to_s.to_sym)
          type.to_s.to_sym
        else
          :string
        end
      end

    end

  end
end