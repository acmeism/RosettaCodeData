require 'prime'

(1..8).each do |n|
  count = Prime.each(10**n).each_cons(2).count{|p1, p2| p2-p1 == 2}
  puts "Twin primes below 10**#{n}: #{count}"
end
