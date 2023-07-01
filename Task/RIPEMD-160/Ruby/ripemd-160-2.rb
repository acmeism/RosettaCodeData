require 'openssl'
puts OpenSSL::Digest::RIPEMD160.hexdigest('Rosetta Code')
