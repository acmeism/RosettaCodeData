require 'prime'

def tau(n) = n.prime_division.inject(1){|res, (d, exp)| res *= exp+1}

res = (1..Integer.sqrt(100_000)).filter_map{|n| sqr = n*n; sqr if tau(sqr).prime? }
res.each_slice(10){|slice| puts "%10d"*slice.size % slice}
