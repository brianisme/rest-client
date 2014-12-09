$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'vcr'
require 'bundler'
Bundler.setup

# Dir.glob(File.expand_path("../support/**/*.rb", __FILE__), &method(:require))

require 'rest-client'

RSpec.configure do |config|
  config.color = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
