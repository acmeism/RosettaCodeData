# Get prime decomposition of integer _i_.
# This routine is terribly inefficient, but elegance rules.
def prime_factors(i)
  v = (2..i-1).detect{|j| i % j == 0}
  v ? ([v] + prime_factors(i/v)) : [i]
end

# Example: Decompose all possible Mersenne primes up to 2**31-1.
# This may take several minutes to show that 2**31-1 is prime.
(2..31).each do |i|
  factors = prime_factors(2**i-1)
  puts "2**#{i}-1 = #{2**i-1} = #{factors.join(' * ')}"
end
