require 'simplecov'
require 'rack/test'
require 'mustermann'

# SimpleCov.start

lib = File.join(File.dirname(__FILE__), '../lib/*.rb')
Dir[File.expand_path(lib)].each { |file| require file }

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
