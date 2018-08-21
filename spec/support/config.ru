%w[rack json mustermann].each { |gem_name| require gem_name }

lib_files = "#{File.expand_path('../../lib', File.dirname(__FILE__))}/*.rb"
Dir[File.expand_path(lib_files)].each { |file| require file }

router = Router.new do
  get '/', to: :home
  get '/hello/:name', to: :hello
  post '/auth', to: :create_session
end

run router.to_app
