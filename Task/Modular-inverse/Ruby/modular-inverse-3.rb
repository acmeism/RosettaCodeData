require 'openssl'
p OpenSSL::BN.new(42).mod_inverse(2017).to_i
