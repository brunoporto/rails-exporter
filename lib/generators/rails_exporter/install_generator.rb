require 'rails/generators/base'

module RailsExporter
  module Generators

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../config", __FILE__)

      def copy_locales
        directory 'locales', 'config/locales'
      end

    end

  end
end