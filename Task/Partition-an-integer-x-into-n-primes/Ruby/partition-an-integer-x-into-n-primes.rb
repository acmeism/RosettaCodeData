require "prime"

def prime_partition(x, n)
  Prime.each(x).to_a.combination(n).detect{|primes| primes.sum == x}
end

TESTCASES = [[99809, 1], [18, 2], [19, 3], [20, 4], [2017, 24],
             [22699, 1], [22699, 2], [22699, 3], [22699, 4], [40355, 3]]

TESTCASES.each do |prime, num|
  res = prime_partition(prime, num)
  str = res.nil? ? "no solution" : res.join(" + ")
  puts  "Partitioned #{prime} with #{num} primes: #{str}"
end
