class Railtie < ::Rails::Railtie
  initializer 'activeservice.autoload', :before => :set_autoload_paths do |app|
    raise app.inspect
    app.config.autoload_paths += %( #{Rails.application.config.root}/app/exporters )
  end
end