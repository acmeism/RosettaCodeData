def prime?(n)                     # P3 Prime Generator primality test
  return n | 1 == 3 if n < 5      # n: 2,3|true; 0,1,4|false
  return false if n.gcd(6) != 1   # this filters out 2/3 of all integers
  pc, sqrtn = 5, Integer.sqrt(n)  # first P3 prime candidates sequence value
  until pc > sqrtn
    return false if n % pc == 0 || n % (pc + 2) == 0  # if n is composite
    pc += 6                       # 1st prime candidate for next residues group
  end
  true
end

def divisors(n)                   # divisors of n -> [1,..,n]
  f = []
  (1..Integer.sqrt(n)).each { |i| (n % i).zero? && (f << i; f << n / i if n / i != i) }
  f.sort
end

# The smallest divisor d of p-1 such that 10^d = 1 (mod p),
# is the length of the period of the decimal expansion of 1/p.
def long_prime?(p)
  return false unless prime? p
  divisors(p - 1).each { |d| return d == (p - 1) if 10.pow(d, p) == 1 }
  false
end

start = Time.now
puts "Long primes ≤ 500:"
(7..500).each { |pc| print "#{pc} " if long_prime? pc }
puts
[500, 1000, 2000, 4000, 8000, 16000, 32000, 64000].each do |n|
  puts "Number of long primes ≤ #{n}: #{(7..n).count { |pc| long_prime? pc }}"
end
puts "\nTime: #{(Time.now - start)} secs"
