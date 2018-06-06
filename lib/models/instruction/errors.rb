class Instruction
  class Errors < Struct.new(:direction, :delay, :steps)
    def initialize(direction = [], delay = [], steps = [])
      super
    end

    def present?
      to_h.values.all?(&:empty?)
    end
  end
end
