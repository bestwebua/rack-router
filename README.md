# Rack Router

Simple Rack Router implementation.

## Router configuration

### Step 1. Create your Rack config file:

```ruby
# config.ru

%w[rack json mustermann].each { |gem_name| require gem_name }
Dir[File.expand_path('lib/*.rb')].each { |file| require_relative file }

router = Router.new do
  get '/', to: :home
  get '/hello/:name', to: :hello
  post '/auth', to: :create_session
end

run router.to_app
```


### Step 2. Define your methods in MethodsToCall class:

```ruby
# lib/methods_to_call.rb

class Router
  class MethodsToCall
    def self.home
      'Hello world'
    end

    def self.hello(params)
      params.to_json
    end

    def self.some_your_method
      # method context
    end
  end
end
```

### Step 3. Run Rack

```bash
$ rackup
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bestwebua/rack-router. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The application is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
