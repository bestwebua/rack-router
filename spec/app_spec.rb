class Router
  class App
    RSpec.describe App do
      let(:app) do
        rack_config = File.expand_path('./support/config.ru', File.dirname(__FILE__))
        Rack::Builder.parse_file(rack_config).first
      end

      let(:status_200)  { expect(last_response.status).to eq(200) }
      let(:status_404)  { expect(last_response.status).to eq(404) }
      let(:body)        { last_response.body }
      let(:random_path) { (0..5).map { |_| ('a'..'z').to_a[rand(0..25)] }.join }

      context 'when route exists' do
        describe '/' do
          before { get('/') }

          specify { status_200 }

          it ':home call' do
            expect(body).to include('Hello world')
          end
        end

        describe '/hello/random_path' do
          before { get("/hello/#{random_path}") }

          specify { status_200 }

          it ':hello call' do
            expect(body).to include("{\"name\":\"#{random_path}\"}")
          end
        end
      end

      context 'when route not exists' do
        before { get("/#{random_path}") }

        specify { status_404 }

        it '404 message' do
          expect(body).to include(Constant::ROUTE_NOT_FOUND)
        end
      end
    end
  end
end
