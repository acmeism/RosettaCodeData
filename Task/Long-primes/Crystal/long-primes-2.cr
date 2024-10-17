require "big"

def prime?(n)                     # P3 Prime Generator primality test
  n = n.to_big_i
  return n | 1 == 3 if n < 5      # n: 0,1,4|false, 2,3|true
  return false if n.gcd(6) != 1   # 1/3 (2/6) of integers are P3 pc
  p = typeof(n).new(5)            # first P3 sequence value
  until p*p > n
    return false if n % p == 0 || n % (p + 2) == 0  # if n is composite
    p += 6      # first prime candidate for next kth residues group
  end
  true
end

def powmod(b, e, m)               # Compute b**e mod m
  r, b = 1, b.to_big_i
  while e > 0
    r = (b * r) % m if e.odd?
    b = (b * b) % m
    e >>= 1
  end
  r
end

def divisors(n)                   # divisors of n -> [1,..,n]
  f = [] of Int32
  (1..Math.sqrt(n)).each { |i| (n % i).zero? && (f << i; f << n // i if n // i != i) }
  f.sort
end

# The smallest divisor d of p-1 such that 10^d = 1 (mod p),
# is the length of the period of the decimal expansion of 1/p.
def long_prime?(p)
  return false unless prime? p
  divisors(p - 1).each { |d| return d == (p - 1) if powmod(10, d, p) == 1 }
  false
end

start = Time.monotonic  # time of starting
puts "Long primes ≤ 500:"
(7..500).each { |pc| print "#{pc} " if long_prime? pc }
puts
[500, 1000, 2000, 4000, 8000, 16000, 32000, 64000].each do |n|
  puts "Number of long primes ≤ #{n}: #{(7..n).count { |pc| long_prime? pc }}"
end
puts "\nTime: #{(Time.monotonic - start).total_seconds} secs"
