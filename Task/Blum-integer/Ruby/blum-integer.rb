require 'prime'

BLUM_EXP = [1, 1]
blums = (1..).step(2).lazy.select do |c|
  next if c % 5 == 0
  primes, exps = c.prime_division.transpose
  exps == BLUM_EXP && primes.all?{|pr| (pr-3) % 4 == 0}
end

n, m = 50, 26828
res =  blums.first(m)
puts "First #{n} Blum numbers:"
res.first(n).each_slice(10){|s| puts "%4d"*s.size % s}

puts "\n#{m}th Blum number: #{res.last}"
