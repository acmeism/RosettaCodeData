module Radical
  refine Integer do
    require 'prime'

    def radical = self == 1 ? 1 : prime_division.map(&:first).inject(&:*)
    def num_uniq_prime_factors = prime_division.size
    def prime_pow? = prime_division.size == 1

  end
end

using Radical

n = 50 # task 1
puts "The radicals for the first #{n} positive integers are:"
(1..n).map(&:radical).each_slice(10){|s| puts "%4d"*s.size % s}
puts # task 2
[99999, 499999 , 999999].each{|n| puts "Radical for %6d: %6d" % [n, n.radical]}
n = 1_000_000 # task 3 & bonus
puts "\nNumbers of distinct prime factors for integers from 1 to #{n}"
(1..n).map(&:num_uniq_prime_factors).tally.each{|kv| puts "%d: %8d" % kv }
puts "\nNumber of primes and powers of primes less than or equal to #{n}: #{(1..n).count(&:prime_pow?)}"
