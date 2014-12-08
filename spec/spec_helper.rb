$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

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
