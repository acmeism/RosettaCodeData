  puts (1..5000).select{|n| n.digits.sum{|d| d**d} == n}
