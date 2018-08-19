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

    def self.home
      'Hello world'
    end

    def self.hello(params)
      params.to_json
    end
  end
end
