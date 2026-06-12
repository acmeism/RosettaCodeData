require 'openssl'

pent_pow_primes = (1..).lazy.select{|n| (0..4).all?{|exp| OpenSSL::BN.new(n**exp + n + 1).prime?} }

n = 30
puts "The first #{n} penta-power prime seeds:"
pent_pow_primes.take(n).each_slice(10){|s| puts "%8s"*s.size % s}
