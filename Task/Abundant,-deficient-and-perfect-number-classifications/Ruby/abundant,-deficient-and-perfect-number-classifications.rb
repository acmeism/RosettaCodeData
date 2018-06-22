res = Hash.new(0)
(1 .. 20_000).each{|n| res[n.proper_divisors.sum <=> n] += 1}
puts "Deficient: #{res[-1]}   Perfect: #{res[0]}   Abundant: #{res[1]}"
