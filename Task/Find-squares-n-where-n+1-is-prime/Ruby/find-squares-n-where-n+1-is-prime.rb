require 'prime'

p (1..Integer.sqrt(1000)).filter_map{|n| sqr = n*n; sqr if (sqr+1).prime? }
