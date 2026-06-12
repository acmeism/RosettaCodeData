require 'prime'

res = [1]+ (2..100).map{|n| n.prime_division.map(&:first).minmax.inject(&:*)}
res.each_slice(10){|slice| puts '%5d'*slice.size % slice}
