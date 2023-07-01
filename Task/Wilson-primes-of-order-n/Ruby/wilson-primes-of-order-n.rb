require "prime"

module Modulo
  refine Integer do
    def factorial_mod(m) = (1..self).inject(1){|prod, n| (prod *= n) % m }
  end
end

using Modulo
primes = Prime.each(11000).to_a

(1..11).each do |n|
  res = primes.select do |pr|
    prpr = pr*pr
    ((n-1).factorial_mod(prpr) * (pr-n).factorial_mod(prpr) - (-1)**n) % (prpr) == 0
  end
  puts "#{n.to_s.rjust(2)}: #{res.inspect}"
end
