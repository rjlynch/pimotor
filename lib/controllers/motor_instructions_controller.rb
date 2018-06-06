# Returns Instruction's response to user input
class MotorInstructionsController
  attr_reader :request_body

  def initialize(request_body)
    @request_body = request_body
  end

  def show
    [Instruction.processed.last.to_json, 200]
  end

  def create
    hash = JSON.parse request_body
    args = hash.fetch_values('direction', 'delay', 'steps')
    instruction = Instruction.new *args

    if instruction.valid?
      instruction.procees
      [instruction.to_json, 201]
    else
      [instruction.errors.to_json, 422]
    end

  rescue KeyError, JSON::ParserError
    [parsing_error.to_json, 400]
  end

  private

  EXAMPLE_REQUEST = {
    'direction': "String, one of 'forward' of 'backwards'",
    'delay': 'Integer, delay in ms between steps',
    'steps': 'Integer, number of steps to perform'
  }.freeze

  def parsing_error
    { parsing_error: { expected: EXAMPLE_REQUEST, received: request_body }}
  end
end
