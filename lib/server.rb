# Calls the appropriate controller action
class Server
  def self.call(env)
    new(env).response.finish
  end

  attr_reader :path, :method, :body

  def initialize(env)
    request = Rack::Request.new(env)
    @path   = request.path
    @method = request.request_method
    @body   = request.body.read
    request.body.rewind
  end

  def response
    Rack::Response.new *controller_klass.new(body).public_send(action)
  rescue NotFound, NotAllowed => error
    error.to_response
  end

  private

  def controller_klass
    route[:klass]
  end

  def action
    route[:methods].fetch(method) { raise NotAllowed, route[:methods].keys }
  end

  def route
    ROUTES.fetch(path) { raise NotFound }
  end

  class NotFound < StandardError
    def to_response
      Rack::Response.new 'Not Found', 404
    end
  end

  class NotAllowed < StandardError
    def initialize(allowed_methods)
      @allowed_methods = allowed_methods
      super
    end

    def to_response
      Rack::Response.new(
        'Method Not Allowed', 405, { 'Allow' => @allowed_methods.join(', ').to_s }
      )
    end
  end
end
