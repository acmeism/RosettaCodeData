require "big"

def prime?(n)                     # P3 Prime Generator primality test
  return n | 1 == 3 if n < 5      # n: 2,3|true; 0,1,4|false
  return false if n.gcd(6) != 1   # this filters out 2/3 of all integers
  pc = typeof(n).new(5)           # first P3 prime candidates sequence value
  until pc*pc > n
    return false if n % pc == 0 || n % (pc + 2) == 0  # if n is composite
    pc += 6                       # 1st prime candidate for next residues group
  end
  true
end

# The smallest divisor d of p-1 such that 10^d = 1 (mod p),
# is the length of the period of the decimal expansion of 1/p.
def long_prime?(p)
  return false unless prime? p
  (2...p).each do |d|
    return d == (p - 1) if (p - 1) % d == 0 && (10.to_big_i ** d) % p == 1
  end
  false
end

start = Time.monotonic  # time of starting
puts "Long primes ≤ 500:"
(2..500).each { |pc| print "#{pc} " if long_prime? pc }
puts
[500, 1000, 2000, 4000, 8000, 16000, 32000, 64000].each do |n|
  puts "Number of long primes ≤ #{n}: #{(7..n).count { |pc| long_prime? pc }}"
end
puts "\nTime: #{(Time.monotonic - start).total_seconds} secs"
