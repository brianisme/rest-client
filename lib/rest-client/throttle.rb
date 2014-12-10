require 'yaml'

module RestClient
  class Throttle
    attr_reader :storage, :limit, :period, :key, :entry, :debounce_after

    def initialize(key, options)
      @storage = options[:store]
      @limit = options[:limit]
      @period = options[:period]
      @key = key
    end

    def add_request
      @entry = nil
      @debounce_after = nil
      if storage.respond_to?(:cas?) && storage.cas?
        result = storage.watch(key) do
          # need to get the entry before getting into pipeline
          @entry = entry
          storage.multi do |multi|
            if exceeded?
              puts "thorttled - sleep for #{debounce_after} seconds"
              sleep debounce_after
              next
            end
            entry << { time: Time.now }
            storage.write(key, YAML.dump(entry))
          end
        end

        # result would be nil if cas is locked
        # it would be [] if the request is throttled
        unless result.kind_of?(Array) && result[0] == 'OK'
          puts "retrying - result: #{result}"
          add_request
        end
      else
        if exceeded?
          puts "thorttled - sleep for #{debounce_after} seconds"
          sleep debounce_after
          add_request
        end
        entry << { time: Time.now }
        storage.write(key, YAML.dump(entry))
      end
    end

    def exceeded?
      return false unless entry.full?
      debounce_after > 0
    end

    private

    def debounce_after
      @debounce_after ||= entry.first[:time] + period - Time.now
    end

    def entry
      @entry ||= storage.exist?(key) ? YAML.load(storage.read(key)) : MaxQueue.new(limit)
    end
  end
end
