require 'prime'

def single_odd?(pr)
  pr.digits.count(&:odd?) == 1
end

res = Prime.each(1000).select {|pr| single_odd?(pr)}
res.each_slice(10){|s| puts "%4d"*s.size % s}

n = 1_000_000
count = Prime.each(n).count{|pr| single_odd?(pr)}
puts "\nFound #{count} single-odd-digit primes upto #{n}."
