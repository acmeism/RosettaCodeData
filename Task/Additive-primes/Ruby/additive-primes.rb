require "prime"

additive_primes = Prime.lazy.select{|prime| prime.digits.sum.prime? }

N = 500
res = additive_primes.take_while{|n| n < N}.to_a
puts res.join(" ")
puts "\n#{res.size} additive primes below #{N}."
