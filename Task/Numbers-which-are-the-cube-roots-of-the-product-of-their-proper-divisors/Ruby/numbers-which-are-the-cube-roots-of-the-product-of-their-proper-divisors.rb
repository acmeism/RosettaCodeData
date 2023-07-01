require 'prime'

def tau(n) = n.prime_division.inject(1){|res, (d, exp)| res *= exp+1}
a111398 = [1].chain (1..).lazy.select{|n| tau(n) == 8}

puts "The first 50 numbers which are the cube roots of the products of their proper divisors:"
p a111398.first(50)
[500, 5000, 50000].each{|n| puts "#{n}th: #{a111398.drop(n-1).next}" }
