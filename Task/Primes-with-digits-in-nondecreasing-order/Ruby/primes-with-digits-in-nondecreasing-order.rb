require 'prime'

base = 10
upto = 1000

res = Prime.each(upto).select do |pr|
   pr.digits(base).each_cons(2).all?{|p1, p2| p1 >= p2}
end

puts "There are #{res.size} non-descending primes below #{upto}:"
puts res.join(", ")
