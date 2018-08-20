class Router
  attr_accessor :resolver

  def initialize(&block)
    @resolver = Resolver.new
    instance_eval(&block) if block_given?
  end

  Constant::REQUEST_METHODS.split.each do |request_method|
    define_method(request_method.downcase) do |path_route, **args|
      add_route(request_method, path_route, args)
    end
  end

  def add_route(request_method, path_route, **args)
    return unless args[:to]
    method_to_call = args[:to]
    resolver.push(request_method, path_route, method_to_call)
  end

  def resolve(request_method, path_route)
    resolver.fetch(request_method, path_route)
  end

  def to_app
    App.new(resolver)
  end
end
