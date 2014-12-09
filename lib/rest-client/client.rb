require 'faraday'
require 'faraday-http-cache'
require 'active_support/cache'

module RestClient
  class Client

    attr_reader :client

    def initialize(host, limit = nil, period = nil, id = nil)
      @client = Faraday.new(host) do |stack|
        stack.use RestClient::Middleware, host: host, limit: limit, period: period, store: store
        stack.use :http_cache, store: store
        stack.adapter Faraday.default_adapter
      end
    end

    %i(get post put delete).each do |method|
      define_method method do |path, option={}|
        client.send(method, path, option)
      end
    end

    private

    def store
      @store ||= ActiveSupport::Cache::MemCacheStore.new('localhost:11211')
    end
  end
end
