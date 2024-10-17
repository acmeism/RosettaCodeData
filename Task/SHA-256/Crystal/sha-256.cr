require "openssl"
puts OpenSSL::Digest.new("SHA256").update("Rosetta code")
