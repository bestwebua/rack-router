class Router
  class Resolver
    attr_accessor :routes

    def initialize
      @routes = Hash.new do |routes, request_method|
        routes[request_method] = []
      end
    end

    def push(request_method, path_route, method_to_call)
      route_data = { pattern(path_route) => method_to_call }
      routes[request_method].push(route_data)
    end

    def fetch(request_method, request_path)
      route_data = find_method_to_call(request_method, request_path)
      if route_data
        [MethodsToCall.public_send(*route_data.reject(&:empty?)), '200']
      else
        [Constant::ROUTE_NOT_FOUND, '404']
      end
    end

    private

    def pattern(path_route)
      Mustermann.new(path_route, type: :rails)
    end

    def find_method_to_call(request_method, request_path)
      pattern_method = routes[request_method].find do |pattern_hash|
        pattern_hash.keys.first === request_path
      end

      return nil unless pattern_method

      pattern_method.map do |pattern, method_to_call|
        [method_to_call, pattern.params(request_path)]
      end.flatten
    end
  end
end
