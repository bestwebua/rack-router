class Router
  class MethodsToCall
    def self.home
      'Hello world'
    end

    def self.hello(params)
      params.to_json
    end
  end
end
