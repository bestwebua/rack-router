class Router
  class App
    attr_reader :resolver

    def initialize(resolver)
      @resolver = resolver
    end

    def call(env)
      request_data = [env['REQUEST_METHOD'], env['PATH_INFO']]
      ['200', {}, [resolver.fetch(*request_data)]]
    end
  end
end
