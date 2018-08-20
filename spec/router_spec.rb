require 'spec_helper'

class Router
  RSpec.describe Router do
    let(:router) { subject }

    describe '#initialize' do
      let(:get_post_stub) do
        allow(router).to receive(:get)
        allow(router).to receive(:post)
      end

      context 'without block' do
        before do
          get_post_stub
          router
        end

        after { router }

        specify { is_expected.not_to have_received(:get) }
        specify { is_expected.not_to have_received(:post) }
      end

      context 'with block' do
        let(:method_calls) do
          lambda do
            get '/', to: :home
            post '/', to: :home
          end
        end

        before do
          get_post_stub
          router.instance_exec(&method_calls)
        end

        after { router.instance_exec(&method_calls) }

        specify { is_expected.to have_received(:get) }
        specify { is_expected.to have_received(:post) }
      end

      describe '#resolver' do
        specify { expect(router.methods).to include(:resolver, :resolver=) }
        specify { expect(router.resolver).to be_an_instance_of(Resolver) }
      end
    end

    Constant::REQUEST_METHODS.split.each do |request_method|
      request_method.downcase!
      describe "##{request_method}" do
        context 'when method exist' do
          specify { expect(router.methods).to include(:"#{request_method}") }
        end

        context 'when method call' do
          let(:request_method_call) { router.send(:"#{request_method}", '/', to: :home) }

          before do
            allow(router).to receive(:add_route)
            request_method_call
          end

          after { request_method_call }

          specify { expect(router).to have_received(:add_route) }
        end
      end
    end
  end
end
