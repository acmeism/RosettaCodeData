require "prime"

def 𝜑(n)
  n.prime_division.inject(1) {|res, (pr, exp)| res *= (pr-1) * pr**(exp-1) }
end

1.upto 25 do |n|
  tot = 𝜑(n)
  puts "#{n}\t #{tot}\t #{"prime" if n-tot==1}"
end

[100, 1_000, 10_000, 100_000].each do |u|
  puts "Number of primes up to #{u}: #{(1..u).count{|n| n-𝜑(n) == 1} }"
end
