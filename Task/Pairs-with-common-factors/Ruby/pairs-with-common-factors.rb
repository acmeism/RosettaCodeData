require "prime"

 def 𝜑(n) = n.prime_division.inject(1) {|res, (pr, exp)| res *= (pr-1) * pr**(exp-1) }
 def a(n) = n*(n-1)/2 + 1 - (1..n).sum{|i| 𝜑(i)}

 puts "Number of pairs with common factors - first 100 terms: "
 puts (1..100).map{|n| a(n) }.join(", ")
 (1..6).each{|e| puts "Term #1e#{e}: #{a(10**e)}"}
