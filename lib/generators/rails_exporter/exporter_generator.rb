require 'rails/generators/base'

module RailsExporter
  class ExporterGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../../templates", __FILE__)

    def generate_exporter
      @exporter_name = file_name.classify
      template "generic_exporter.erb", File.join('app/exporters', "#{file_name.underscore}_exporter.rb")
    end
  end
end