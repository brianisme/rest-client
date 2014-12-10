require 'redis'

module RestClient
  class RedisStore < Redis
    attr_reader :namespace

    def initialize(options = {})
      super options
      @namespace = options[:namespace]
    end

    def read(key)
      get(namespaced_key(key))
    end

    def write(key, value, options = {})
      set(namespaced_key(key), value, options)
    end

    def watch(*keys, &block)
      super(*namespaced_key(keys), &block)
    end

    def exists(key)
      super(namespaced_key(key))
    end

    def cas?
      true
    end

    def namespaced_key(key)
      if key.kind_of?(Array)
        key.map { |k| namespaced_key(k) }
      else
        "#{namespace}:#{key}"
      end
    end

    alias_method :delete, :del
    alias_method :exist?, :exists
  end
end
