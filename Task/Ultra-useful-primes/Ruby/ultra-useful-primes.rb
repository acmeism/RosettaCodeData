require 'openssl'

(1..10).each do |n|
   pow = 2 ** (2 ** n)
   print "#{n}:\t"
   puts (1..).step(2).detect{|k| OpenSSL::BN.new(pow-k).prime?}
end
