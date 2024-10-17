require "openssl"
puts OpenSSL::Digest.new("sha1").update("Rosetta Code")
