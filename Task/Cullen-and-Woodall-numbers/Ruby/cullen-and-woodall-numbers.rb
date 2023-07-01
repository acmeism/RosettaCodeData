require 'openssl'

cullen  = Enumerator.new{|y| (1..).each{|n| y << (n*(1<<n) + 1)} }
woodall = Enumerator.new{|y| (1..).each{|n| y << (n*(1<<n) - 1)} }
cullen_primes  = Enumerator.new{|y| (1..).each {|i|y << i if OpenSSL::BN.new(cullen.next).prime?}}
woodall_primes = Enumerator.new{|y| (1..).each{|i|y << i if OpenSSL::BN.new(woodall.next).prime?}}

num = 20
puts "First #{num} Cullen numbers:\n#{cullen.first(num).join(" ")}"
puts "First #{num} Woodal numbers:\n#{woodall.first(num).join(" ")}"
puts "First 5 Cullen primes:\n#{cullen_primes.first(5).join(", ")}"
puts "First 12 Woodall primes:\n#{woodall_primes.first(12).join(", ")}"
