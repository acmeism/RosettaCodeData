require "big"

module Primes
  module MillerRabin

    def prime?(k = 15)             # increase k for more confidence
      neg_one_mod = d = self - 1
      s = 0
      while d.even?; d >>= 1; s += 1 end  # d is odd after s shifts
      k.times do
        b = 2 + rand(self - 4)     # random witness base b
        y = powmod(b, d, self)     # y = (b**d) mod self
        next if y == 1 || y == neg_one_mod
        (s - 1).times do
          y = (y * y) % self       # y = (y**2) mod self
          return false if y == 1
          break if y == neg_one_mod
        end
        return false if y != neg_one_mod
      end
      true                         # prime (with high probability)
    end

    # Compute b**e mod m
    private def powmod(b, e, m)
      r, b = 1, b.to_big_i
      while e > 0
        r = (b * r) % m if e.odd?
        b = (b * b) % m
        e >>= 1
      end
      r
    end
  end
end

struct Int; include Primes::MillerRabin end

puts 341521.prime?(20) # => true
puts 341531.prime?     # => false
