# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazada/version'

Gem::Specification.new do |spec|
  spec.name          = "lazada-open-api"
  spec.version       = Lazada::VERSION
  spec.authors       = ["Esteban Bouza Padin"]
  spec.email         = ["esteban@splitdragon.com"]

  spec.summary       = %q{A ruby wrapper for Lazada Open API.}
  spec.description   = %q{A ruby wrapper for Lazada Open API.}
  spec.homepage      = "https://github.com/estebanbouza/lazada-open-api"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "builder", '~> 3.2'
  spec.add_dependency "httparty", "~> 0.13.7"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
