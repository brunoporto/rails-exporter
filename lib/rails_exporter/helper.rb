require 'rails_exporter/base'

module RailsExporter
  module Helper

    define_method "export_to" do |ext, context=:default, params: nil|
      exec_method(ext, context, params)
    end

    private
    def get_obj_class
      (self.first.class rescue nil)
    end
    def exec_method(ext, context, params=nil)
      klass = get_obj_class
      exporter_klass = "#{klass.name}_exporter".classify.constantize
      # RailsExporter::Base.file_types
      if exporter_klass and exporter_klass.respond_to?("export_to_#{ext}")
        exporter_klass.send("export_to_#{ext}", self, context, params)
      end
    end
  end

end

#INJETANDO METODO para_* em um conjunto de array
class Array
  include RailsExporter::Helper
end

#INJETANDO METODO para_* em um conjunto de registros ActiveRecord::Relation
module ActiveRecord
  class Relation
    include RailsExporter::Helper
  end
end