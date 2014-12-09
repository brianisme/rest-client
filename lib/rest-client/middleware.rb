require 'faraday'

module RestClient
  class Middleware < Faraday::Middleware

    attr_reader :options, :throttle

    def initialize(app, options = {})
      super(app)
      @options = options
    end

    def call(env)
      throttle.add_request if throttle?
      @app.call(env)
    end

    private

    def throttle?
      @options[:limit].present? && @options[:period].present?
    end

    def throttle
      return unless throttle?
      @throttle ||= Throttle.new(key, options)
    end

    def key
      "#{@options[:host]}_#{@options[:id]}"
    end
  end
end
