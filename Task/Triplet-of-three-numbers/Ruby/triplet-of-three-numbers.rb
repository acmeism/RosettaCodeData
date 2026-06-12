require 'prime'

primes = Prime.each(6000)
p primes.each_cons(3).filter_map{|p1, p2, p3| p1 + 1 if p1+4 == p2 && p1+6 == p3}
