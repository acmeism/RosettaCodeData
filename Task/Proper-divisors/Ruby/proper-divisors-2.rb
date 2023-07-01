#Determine the integer within a range of integers that has the most proper divisors
#Nigel Galloway: December 23rd., 2014
require "prime"
n, g = 0
(1..20000).each{|i| e = i.prime_division.inject(1){|n,g| n * (g[1]+1)}
                    n, g = e, i if e > n}
puts "#{g} has #{n-1} proper divisors"
