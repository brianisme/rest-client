require 'yaml'

module RestClient
  class Throttle
    attr_reader :storage, :limit, :period, :key, :entry

    def initialize(key, options)
      @storage = options[:store]
      @limit = options[:limit]
      @period = options[:period]
      @key = key
    end

    def add_request
      p 'adding'
      if storage.respond_to?(:cas?) && storage.cas?
        result = storage.watch(key) do
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
        p 3
        add_request unless result.present? && result[0] == 'OK'
      else
        while exceeded?
          puts "thorttled - sleep for #{debounce_after} seconds"
          sleep debounce_after
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

    # TODO: some margin?
    def debounce_after
      entry.first[:time] + period - Time.now
    end

    def entry
      @entry ||= storage.read(key).present? ? YAML.load(storage.read(key)) : MaxQueue.new(limit)
    end
  end
end
