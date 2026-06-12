require 'prime'

sum, n = 0, 30
extreme_primes = Prime.lazy.filter_map{|pr|sum += pr; [pr, sum] if sum.prime?}

puts "The first #{n} extreme primes are:"
extreme_primes.first(30).map(&:last).each_slice(10){|slice| puts "%8d"*slice.size % slice}

sum = 0
puts
extreme_primes.first(5000).each_slice(1000).with_index(1) do|slice, i|
  puts "The %dth extreme prime is sum of primes upto %10d: %12d" % [i*1000, *slice.last]
end
