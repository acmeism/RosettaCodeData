def taxicab_number(nmax=1200)
  [*1..nmax].repeated_combination(2).group_by{|x,y| x**3 + y**3}.select{|k,v| v.size>1}.sort
end

t = [0] + taxicab_number

[*1..25, *2000...2007].each do |i|
  puts "%4d: %10d" % [i, t[i][0]] + t[i][1].map{|a| " = %4d**3 + %4d**3" % a}.join
end
