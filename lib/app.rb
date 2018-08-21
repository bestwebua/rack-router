class Router
  class App
    attr_reader :resolver

    def initialize(resolver)
      @resolver = resolver
    end

    def call(env)
      request_data = [env['REQUEST_METHOD'], env['PATH_INFO']]
      response_with_status = resolver.fetch(*request_data)
      Rack::Response.new(*response_with_status, {})
    end
  end
end
