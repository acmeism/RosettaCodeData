require 'prime'

digits = [9,8,7,6,5,4,3,2,1]
res = 1.upto(digits.size).flat_map do |n|
   digits.combination(n).filter_map do |set|
      candidate = set.join.to_i
      candidate if candidate.prime?
   end.reverse
 end

 puts res.join(",")
