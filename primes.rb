# Infinite stream of prime numbers in Ruby

module Primes
  class << self

    def cons_stream(car, &cdr_proc)
      Enumerator.new do |y|
        loop do
          y << car
          car, cdr = stream_carcdr(cdr_proc.call)
          cdr_proc = -> { cdr }
        end
      end
    end

    def stream_carcdr(stream)
      car = stream.next
      cdr = stream
      [car, cdr]
    end

    def integers_starting_from(n)
      cons_stream(n) { integers_starting_from(n+1) }
    end


    def stream_filter(stream, &pred)
      car, cdr = stream_carcdr(stream)
      if pred.call(car)
        cons_stream(car) { stream_filter(cdr, &pred) }
      else
        stream_filter(cdr, &pred)
      end
    end


    def sieve(stream)
      car, cdr = stream_carcdr(stream)
      cons_stream(car) {
        sieve(stream_filter(cdr) { |x| x % car != 0 })
      }
    end

    def primes
      sieve(integers_starting_from(2))
    end

  end

end
