require 'prime'

n = 1000000
pr1, pr2 = Prime.each(n).each_cons(2).max_by{|p1,p2| p2-p1}
puts "Largest difference between adjacent primes under #{n} is #{pr2-pr1} (#{pr2}-#{pr1})."
