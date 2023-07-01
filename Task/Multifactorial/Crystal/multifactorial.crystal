def multifact(n, d)
  n.step(to: 1, by: -d).product
end

(1..5).each {|d| puts "Degree #{d}: #{(1..10).map{|n| multifact(n, d)}.join "\t"}"}
