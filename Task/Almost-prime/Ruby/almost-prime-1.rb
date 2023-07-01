require 'prime'

def almost_primes(k=2)
  return to_enum(:almost_primes, k) unless block_given?
  1.step {|n| yield n if n.prime_division.sum( &:last ) == k }
end

(1..5).each{|k| puts almost_primes(k).take(10).join(", ")}
