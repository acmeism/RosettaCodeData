require "big"

def prime?(n)                             # P3 Prime Generator primality test
  return n | 1 == 3 if n < 5              # n: 0,1,4|false, 2,3|true
  return false if n.gcd(6) != 1           # for n a P3 prime candidate (pc)
  pc1, pc2 = -1, 1                        # use P3's prime candidates sequence
  until (pc1 += 6) > Math.sqrt(n).to_i    # pcs are only 1/3 of all integers
    return false if n % pc1 == 0 || n % (pc2 += 6) == 0  # if n is composite
  end
  true
end

# Compute b**e mod m
def powmod(b, e, m)
  r, b = 1.to_big_i, b.to_big_i
  while e > 0
    r = (r * b) % m if e.odd?
    b = (b * b) % m
    e >>= 1
  end
  r
end

def mersenne_factor(p)
  mers_num = 2.to_big_i ** p - 1
  kp2 = p2 = 2.to_big_i *  p
  while (kp2 - 1) ** 2 < mers_num
    q  = kp2 + 1     # return q if it's a factor
    return q if [1, 7].includes?(q % 8) && prime?(q) && (powmod(2, p, q) == 1)
    kp2 += p2
  end
  true    # could also set to `0` value to check for
end

def check_mersenne(p)
  print "M#{p} = 2**#{p}-1 is "
  f = mersenne_factor(p)
  (puts "prime"; return) if f.is_a?(Bool)  # or f == 0
  puts "composite with factor #{f}"
end

(2..53).each { |p| check_mersenne(p) if prime?(p) }
check_mersenne 929
