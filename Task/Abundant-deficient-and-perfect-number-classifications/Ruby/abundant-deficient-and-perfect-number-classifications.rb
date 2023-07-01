res = (1 .. 20_000).map{|n| n.proper_divisors.sum <=> n }.tally
puts "Deficient: #{res[-1]}   Perfect: #{res[0]}   Abundant: #{res[1]}"
