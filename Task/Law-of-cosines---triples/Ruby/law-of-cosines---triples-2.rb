n  = 10_000
ar = (1..n).to_a
squares = {}
ar.each{|i| squares[i*i] = true }
count = ar.combination(2).count{|a,b| squares.key?(a*a + b*b - a*b)}

puts "There are #{count} 60° triangles with unequal sides of max size #{n}."
