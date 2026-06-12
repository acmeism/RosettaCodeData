require 'prime'

primes = Prime.each
primes.next # skip 2
primes.first(20).each{|pr| puts "%3d + %3d = %3d" % [pr/2, pr/2+1, pr]}
