require 'yaml'

module RestClient
  class Throttle

    attr_reader :storage, :limit, :period, :key, :entry

    def initialize(key, options)
      @storage = options[:store]
      @limit = options[:limit]
      @period = options[:period]
      @key = key
      storage.write(key, YAML.dump(MaxQueue.new(limit))) unless storage.exist?(key)
    end

    def add_request
      while exceeded?
        puts "thorttled - sleep for #{debounce_after} seconds"
        sleep debounce_after
      end
      stored_entry = entry
      stored_entry << { time: Time.now }
      storage.write(key, YAML.dump(stored_entry))
    end

    def exceeded?
      return false unless entry.full?
      debounce_after > 0
    end

    private

    # TODO: some margin?
    def debounce_after
      entry.first[:time] + period - Time.now
    end

    def entry
      YAML.load(storage.read(key))
    end
  end
end
