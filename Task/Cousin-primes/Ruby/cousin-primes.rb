require 'prime'
primes = Prime.each(1000).to_a
p cousins = primes.filter_map{|pr| [pr, pr+4] if primes.include?(pr+4) }
puts "#{cousins.size} cousins found."
