a131382  = (0..).lazy.map{|n| (1..).detect{|m|(n*m).digits.sum == n} }
a131382.take(70).each_slice(10){|slice| puts "%8d"*slice.size % slice }
