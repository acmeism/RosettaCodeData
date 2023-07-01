require 'openssl'

a = (1..).step(2).lazy.select do |k|
  next if k == 1
  (1..(k-1)).none? {|m| OpenSSL::BN.new(k+(2**m)).prime?}
end
p a.first 5
