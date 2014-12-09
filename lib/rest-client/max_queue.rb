module RestClient
  class MaxQueue < Array

    attr_reader :max

    def initialize(max)
      super()
      @max = max
    end

    def push(value)
      shift if size >= @max
      super(value)
    end

    def full?
      size == max
    end

    def <<(value)
      push(value)
    end

    def []=(idx, value)
      raise IndexError.new("index #{idx} is over the maxium #{@max}") if idx >= max
      super(idx, value)
    end

  end
end
