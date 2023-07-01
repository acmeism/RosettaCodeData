require "big"

def is_prime(n)                           # P3 Prime Generator primality test
  return n | 1 == 3 if n < 5              # n: 0,1,4|false, 2,3|true
  return false if n.gcd(6) != 1           # for n a P3 prime candidate (pc)
  pc1, pc2 = -1, 1                        # use P3's prime candidates sequence
  until (pc1 += 6) > Math.sqrt(n).to_i    # pcs are only 1/3 of all integers
    return false if n % pc1 == 0 || n % (pc2 += 6) == 0  # if n is composite
  end
  true
end

def is_mersenne_prime(p)
  return true  if p == 2
  m_p = (1.to_big_i << p) - 1
  s = 4
  (p - 2).times { s = (s**2 - 2) % m_p }
  s == 0
end

precision = 20000   # maximum requested number of decimal places of 2 ** MP-1 #
long_bits_width = precision / Math.log(2) * Math.log(10)
upb_prime = (long_bits_width - 1).to_i // 2    # no unsigned #
upb_count = 45      # find 45 mprimes if int was given enough bits #

puts "Finding Mersenne primes in M[2..%d]:" % upb_prime

count = 0
(2..upb_prime).each do |p|
  if is_prime(p) && is_mersenne_prime(p)
    print "M%d " % p
    count += 1
  end
  break  if count >= upb_count
end
puts
