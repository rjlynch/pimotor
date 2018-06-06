class Instruction
  class Processed
    MAX_SIZE = 100 # dont infinitley grow memory

    def initialize
      @array = []
    end

    def <<(arg)
      @array.shift if @array.size > MAX_SIZE
      @array << arg
    end

    private

    def respond_to_missing?(name, include_private = false)
      @array.respond_to?(name, include_private)
    end

    def method_missing(method, *args, &block)
      @array.public_send(method, *args, &block)
    end
  end
end
