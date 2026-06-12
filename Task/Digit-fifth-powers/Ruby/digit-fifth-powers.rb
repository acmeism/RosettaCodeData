arr = (2..9**5*6).select{|n| n.digits.sum{|d| d**5} == n }
puts "#{arr.join(" + ")} = #{arr.sum}"
