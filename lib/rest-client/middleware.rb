require 'faraday'

module RestClient
  class Middleware < Faraday::Middleware

    attr_reader :options

    def initialize(app, options = {})
      super(app)
      @options = options
    end

    def call(env)
      # do something with the request
      puts 'in the middleware'
      # @app.call(env).on_complete do |env|
        # do something with the response
        # env[:response] is now filled in
      # end
    end
  end
end
