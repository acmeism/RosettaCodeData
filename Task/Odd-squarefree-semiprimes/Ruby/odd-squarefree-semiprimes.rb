require 'prime'

res = (1..1000).step(2).select {|n| n.prime_division.map(&:last) == [1, 1] }
res.each_slice(20){|slice| puts "%4d"*slice.size % slice}
puts "\nCount: #{res.count}"
