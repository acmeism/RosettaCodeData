require 'prime'

honakers = Prime.each.with_index(1).lazy.select{|pr, i| pr.digits.sum == i.digits.sum}
ar = honakers.take(10_000).to_a
puts "The first 50 Honaker primes and their position:"
ar.first(50).each_slice(5){|slice| puts "%15s"*slice.size % slice}

puts "\nHonaker prime 10000 is %d on position %d." %  ar.last
