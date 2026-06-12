require 'openssl'
(0..).each{|n| puts "2**#{n} - 1" if OpenSSL::BN.new(2**n -1).prime? }
