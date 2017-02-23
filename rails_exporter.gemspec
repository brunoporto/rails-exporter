# $:.push File.expand_path("../lib", __FILE__)
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require "rails_exporter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rails-exporter"
  spec.version     = RailsExporter::VERSION
  spec.authors     = ["Bruno Porto"]
  spec.email       = ["brunotporto@gmail.com"]
  spec.homepage    = "https://github.com/brunoporto/rails-exporter"
  spec.summary     = "Rails Exporter"
  spec.description = "Rails Exporter (CSV, XML, XLS)"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'rails', ['>= 3','< 6']
  spec.add_dependency 'rubyXL', '~> 3.3'
  spec.add_dependency 'spreadsheet', '~> 1.1'
  spec.add_dependency 'builder', '~> 3.0'

  # s.add_development_dependency "sqlite3"
end
