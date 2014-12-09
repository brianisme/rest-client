# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest-client/version'

Gem::Specification.new do |spec|
  spec.name          = "rest-client"
  spec.version       = RestClient::VERSION
  spec.authors       = ["Brian Chen"]
  spec.email         = ["brian@updater.com"]
  spec.summary       = "A REST client that wraps around Faraday"
  spec.description   = "with throttle and cache features"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency 'faraday', '~> 0.8'
  spec.add_dependency 'faraday-http-cache'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'dalli'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
