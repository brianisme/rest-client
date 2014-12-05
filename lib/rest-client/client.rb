require 'faraday'
require 'faraday-http-cache'

module RestClient
  class Client

    def initialize(*args)
      Faraday.new('https://api.github.com') do |stack|
        stack.use :http_cache
        stack.adapter Faraday.default_adapter
      end
    end

    # %i(get post put delete).each do |method|
    #   define_method method do |path, option={}|

    #   end
    # end
  end
end
