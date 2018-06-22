require 'prime'

def factors m
  return [1] if 1==m
  primes, powers = Prime.prime_division(m).transpose
  ranges = powers.map{|n| (0..n).to_a}
  ranges[0].product( *ranges[1..-1] ).
  map{|es| primes.zip(es).map{|p,e| p**e}.reduce :*}.
  sort
end

[1, 7, 45, 100].each{|n| p factors n}
