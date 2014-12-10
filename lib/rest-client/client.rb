require 'faraday'
require 'faraday-http-cache'

module RestClient
  class Client

    attr_reader :client

    def initialize(host, options = {})
      @client = Faraday.new(host) do |stack|
        stack.use :http_cache, store: options[:store]
        stack.use RestClient::Middleware, options
        stack.adapter Faraday.default_adapter
      end
    end

    %i(get post put delete).each do |method|
      define_method method do |path, option={}|
        client.send(method, path, option)
      end
    end
  end
end
