require 'prime'

def almost_primes(k=2)
  return to_enum(:almost_primes, k) unless block_given?
  n = 0
  loop do
    n += 1
    yield n if n.prime_division.map( &:last ).inject( &:+ ) == k
  end
end

(1..5).each{|k| puts almost_primes(k).take(10).join(", ")}
