from sys import stdout
from math import sqrt, log

def is_prime ( p ):
  if p == 2: return True # Lucas-Lehmer test only works on odd primes
  elif p <= 1 or p % 2 == 0: return False
  else:
    for i in range(3, int(sqrt(p))+1, 2 ):
      if p % i == 0: return False
    return True

def is_mersenne_prime ( p ):
  if p == 2:
    return True
  else:
    m_p = ( 1 << p ) - 1
    s = 4
    for i in range(3, p+1):
      s = (s ** 2 - 2) % m_p
    return s == 0

precision = 20000   # maximum requested number of decimal places of 2 ** MP-1 #
long_bits_width = precision * log(10, 2)
upb_prime = int( long_bits_width - 1 ) / 2    # no unsigned #
upb_count = 45      # find 45 mprimes if int was given enough bits #

print (" Finding Mersenne primes in M[2..%d]:"%upb_prime)

count=0
for p in range(2, upb_prime+1):
  if is_prime(p) and is_mersenne_prime(p):
    print("M%d"%p),
    stdout.flush()
    count += 1
  if count >= upb_count: break
print
