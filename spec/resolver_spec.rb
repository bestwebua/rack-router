require 'spec_helper'

class Router
  class Resolver
    RSpec.describe Resolver do
      let(:resolver)                  { subject }
      let(:routes)                    { resolver.routes }
      let(:request_method)            { 'GET' }
      let(:path_route)                { '/hello/:name' }
      let(:method_to_call)            { :hello }
      let(:push_args)                 { [request_method, path_route, method_to_call] }
      let(:pattern)                   { resolver.send(:pattern, path_route) }
      let(:existing_request_path)     { '/hello/bob' }
      let(:not_existing_request_path) { '/hello/bob/1' }

      describe '#initialize' do
        specify { expect(routes).to be_an_instance_of(Hash) }
        specify { expect(resolver.methods).to include(:routes, :routes=) }
      end

      describe '#pattern' do
        specify do
          expect(resolver.send(:pattern, path_route)).to be_a(Mustermann::Rails)
        end
      end

      describe '#push' do
        before { resolver.push(*push_args) }

        specify { expect(routes).to have_key(request_method) }
        specify { expect(routes[request_method].first).to eq(pattern => method_to_call) }
      end

      describe '#find_method_to_call' do
        before { resolver.push(*push_args) }

        def search_path_route(request_path)
          resolver.send(:find_method_to_call, request_method, request_path)
        end

        context 'when pattern_method found' do
          let(:find_method_result) do
            [method_to_call, pattern.params(existing_request_path)]
          end

          specify do
            expect(search_path_route(existing_request_path)).to eq(find_method_result)
          end
        end

        context 'when pattern_method not found' do
          specify do
            expect(search_path_route(not_existing_request_path)).to be_nil
          end
        end
      end

      describe '#fetch' do
        before { resolver.push(*push_args) }

        context 'when request_path found' do
          def fetch_existing_request_path(request_path)
            resolver.send(:fetch, request_method, request_path)
          end

          context 'with params' do
            let(:found_response) do
              [MethodsToCall.public_send(:hello, name: 'bob'), '200']
            end

            specify do
              expect(fetch_existing_request_path(existing_request_path)).to eq(found_response)
            end
          end

          context 'without params' do
            before { resolver.push('GET', '/', :home) }

            let(:found_response) do
              [MethodsToCall.public_send(:home), '200']
            end

            specify do
              expect(fetch_existing_request_path('/')).to eq(found_response)
            end
          end
        end

        context 'when request_path not found' do
          let(:fetch_not_existing_request_path) do
            resolver.send(:fetch, request_method, not_existing_request_path)
          end
          let(:not_found_response) { [Constant::ROUTE_NOT_FOUND, '404'] }

          specify do
            expect(fetch_not_existing_request_path).to eq(not_found_response)
          end
        end
      end
    end
  end
end
