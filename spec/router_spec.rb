require 'spec_helper'

class Router
  RSpec.describe Router do
    describe '#initialize' do
      let(:router_with_block) do
        Router.new do
          get '/', to: :home
          post '/', to: :home
        end
      end

      context 'without block' do
        specify { expect(subject.resolver).to be_an_instance_of(Resolver) }
      end

      context 'with block' do
        specify do
          expect(router_with_block.resolver.routes.keys).to eq(Constant::REQUEST_METHODS.split)
        end
      end
    end
  end
end
