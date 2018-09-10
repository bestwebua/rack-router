require 'spec_helper'

class Router
  class Constant
    RSpec.describe Constant do
      %w[ROUTE_NOT_FOUND REQUEST_METHODS].each do |constant|
        describe "#{constant}" do
          specify { expect(constant).not_to be(nil) }
        end
      end
    end
  end
end
