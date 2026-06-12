require 'prime'

puts "Primes below #{n=4000} which start and end with #{d=3}: "
p Prime.each(n).select{|pr| p_d = pr.digits; p_d.first == d && p_d.last == d}

print "\nCount of primes below #{n=1_000_000} which start and en with #{d=3}: "
puts Prime.each(n).count{|pr| p_d = pr.digits; p_d.first == d && p_d.last == d}
