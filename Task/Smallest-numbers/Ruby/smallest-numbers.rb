memo = Hash.new{|h, k| h[k] = (k**k).to_s }
res = (0..50).map{|n| (1..).detect{|m| memo[m].include? n.to_s} }
res.each_slice(10){|slice| puts "%4d"*slice.size % slice }
