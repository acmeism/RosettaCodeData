require 'openssl'

quad_pow_primes = (1..).lazy.select{|n| (1..4).all?{|exp| OpenSSL::BN.new(n**exp + n + 1).prime?} }

n = 50
puts "The first #{n} quad-power prime seeds:"
quad_pow_primes.take(n).each_slice(10){|s| puts "%8s"*s.size % s}
