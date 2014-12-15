# -*- ruby -*-

#server:
# bundle exec thin start -R config.ru -p 3000
#client:
# curl -i -N http://localhost:3000/

require 'rack/stream'
require './primes'

class App
  include Rack::Stream::DSL

  stream do
    after_open do
      primes_stream = Primes.primes
      @timer = EM.add_periodic_timer(1) do
        chunk "#{primes_stream.next}\n"
      end
    end

    before_close do
      @timer.cancel
      @timer = nil
    end

    [200, {'Content-Type' => 'text/html'}, []]
  end
end

app = Rack::Builder.app do
  use Rack::Stream
  run App.new
end

run app
