require 'spec_helper'

class Router
  RSpec.describe Router do
    describe '#initialize' do
      let(:router) { subject }
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
  end
end
