# Get prime decomposition of integer _i_.
# This routine is more efficient than prime_factors,
# and quite similar to Integer#prime_division of MRI 1.9.
def prime_factors_faster(i)
  factors = []
  check = proc do |p|
    while(q, r = i.divmod(p)
          r.zero?)
      factors << p
      i = q
    end
  end
  check[2]
  check[3]
  p = 5
  while p * p <= i
    check[p]
    p += 2
    check[p]
    p += 4    # skip multiples of 2 and 3
  end
  factors << i if i > 1
  factors
end

# Example: Decompose all possible Mersenne primes up to 2**70-1.
# This may take several minutes to show that 2**61-1 is prime,
# but 2**62-1 and 2**67-1 are not prime.
(2..70).each do |i|
  factors = prime_factors_faster(2**i-1)
  puts "2**#{i}-1 = #{2**i-1} = #{factors.join(' * ')}"
end
