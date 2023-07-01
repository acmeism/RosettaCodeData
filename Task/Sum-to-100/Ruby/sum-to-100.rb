digits = ("1".."9").to_a

ar = ["+", "-", ""].repeated_permutation(digits.size).filter_map do |op_perm|
  str = op_perm.zip(digits).join
  str unless str.start_with?("+")
end
res = ar.group_by{|str| eval(str)}

puts res[100] , ""

sum, solutions = res.max_by{|k,v| v.size}
puts "#{sum} has #{solutions.size} solutions.", ""

no_solution = (1..).find{|n| res[n] == nil}
puts "#{no_solution} is the lowest positive number without a solution.", ""

puts res.max(10).map{|pair| pair.join(": ")}
