require 'rails_exporter/exporter'

module RailsExporter
  class Base
    include RailsExporter::Exporter

    class_attribute :exporters

    class << self
      def file_types
        [:csv, :xls, :xlsx, :xml]
      end

      # def method_missing(m, *args, &block)
      #   if m =~ /_url|_path/
      #     Rails.application.routes.url_helpers.send(m, args)
      #   end
      # end

      def exporter(context=:default, &block)
        (self.exporters ||= {})[context] ||= []
        @exporter_context = context
        block.call if block_given?
        self.exporters[context]
      end

      def column(attr, &block)
        if attr.is_a?(Hash)
          attribute = attr.keys.first.to_s.to_sym
          type = attr.values.first.to_s.to_sym
        else
          attribute = attr.to_sym
          type = :string
        end

        exporter_name_without_suffix = self.to_s.underscore.gsub('_exporter','')
        label = I18n.t("#{@exporter_context}.#{attribute}", default: [attribute.to_sym, attribute.to_s.humanize], scope: [:exporters, exporter_name_without_suffix])
        self.exporters[@exporter_context] << {column: attribute, label: label, type: normalize_type(type), block: (block_given? ? block : nil)}
      end

      def columns(exporter_name=:default)
        self.exporters[exporter_name]
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