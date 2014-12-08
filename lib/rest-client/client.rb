require 'faraday'
require 'faraday-http-cache'

module RestClient
  class Client

    attr_reader :client

    def initialize(*args)
      @client = Faraday.new('http://www.google.com') do |stack|
        stack.use RestClient::Middleware, limit: 50, period: 60
        stack.use :http_cache
        stack.adapter Faraday.default_adapter
      end
    end

    # %i(get post put delete).each do |method|
    #   define_method method do |path, option={}|
    #     # if not throttled
    #       @client.send(method, path, option)
    #       # dequene
    #     # throttle
    #     @storage

    #   end
    # end
  end
end
