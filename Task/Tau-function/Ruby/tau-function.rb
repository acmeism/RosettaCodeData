require 'prime'

def tau(n) = n.prime_division.inject(1){|res, (d, exp)| res *= exp + 1}

(1..100).map{|n| tau(n).to_s.rjust(3) }.each_slice(20){|ar| puts ar.join}
