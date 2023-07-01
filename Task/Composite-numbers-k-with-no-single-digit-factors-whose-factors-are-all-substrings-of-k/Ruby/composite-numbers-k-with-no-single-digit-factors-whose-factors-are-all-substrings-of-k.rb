require 'prime'

generator2357 = Enumerator.new do |y|
  gen23 = Prime::Generator23.new
  gen23.each {|n| y << n unless (n%5 == 0 || n%7 == 0) }
end

res = generator2357.lazy.select do |n|
  primes, exp = n.prime_division.transpose
  next if exp.sum < 2 #exclude primes
  s = n.to_s
  primes.all?{|pr| s.match?(-pr.to_s) }
end

res.take(10).each{|n| puts n}
