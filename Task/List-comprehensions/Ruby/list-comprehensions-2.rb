n = 20
p (1..n).to_a.combination(3).select{|a,b,c| a*a + b*b == c*c}
