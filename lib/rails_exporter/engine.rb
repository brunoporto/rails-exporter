module RailsExporter
  class Engine < ::Rails::Engine
    engine_name "rails_exporter"

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
