# Translates from user input to motor actions
require_relative './instruction/processed.rb'
require_relative './instruction/errors.rb'
class Instruction
  QUEUE = Queue.new
  PROCESSED = Processed.new

  VALID_DIRECTIONS = %w(forward backwards).freeze

  attr_reader :direction, :delay, :steps, :errors

  def self.queue
    QUEUE
  end

  def self.processed
    PROCESSED
  end

  def initialize(direction, delay, steps)
    @direction = direction
    @delay = delay
    @steps = steps
    @errors = Errors.new
  end

  def procees
    return false unless valid?
    QUEUE.push self
  end

  def valid?
    validate_direction
    validate_delay
    validate_steps
    errors.present?
  end

  def to_a
    [direction, delay, steps]
  end

  def to_h
    Hash[%w(direction delay steps).zip to_a]
  end

  def to_json
    to_h.to_json
  end

  private

  def validate_direction
    return true if VALID_DIRECTIONS.include?(direction)
    errors.direction << "is not a valid direction, valid directions are: #{VALID_DIRECTIONS}"
    return false
  end

  def validate_delay
    return true if is_number?(delay)
    errors.delay << 'is not a number'
    return false
  end

  def validate_steps
    return true if is_number?(steps)
    errors.delay << 'is not a number'
    return false
  end

  def is_number?(number)
    Float number
    true
  rescue ArgumentError
    false
  end
end

