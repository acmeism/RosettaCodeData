def isqrt(n):
    if n < 0:
        raise ValueError
    elif n < 2:
        return n
    else:
        a = 1 << ((1 + n.bit_length()) >> 1)
        while True:
            b = (a + n // a) >> 1
            if b >= a:
                return a
            a = b

def isprime(n):
    if n < 5:
        return n == 2 or n == 3
    elif n%2 == 0:
        return False
    else:
        r = isqrt(n)
        k = 3
        while k <= r:
            if n%k == 0:
                return False
            k += 2
        return True

def lucas_lehmer_fast(n):
    if n == 2:
        return True
    elif not isprime(n):
        return False
    else:
        m = 2**n - 1
        s = 4
        for i in range(2, n):
            sqr = s*s
            s = (sqr & m) + (sqr >> n)
            if s >= m:
                s -= m
            s -= 2
        return s == 0

# test taken from the previous rosetta implementation

from math import log
from sys import stdout

precision = 20000   # maximum requested number of decimal places of 2 ** MP-1 #
long_bits_width = precision * log(10, 2)
upb_prime = int( long_bits_width - 1 ) / 2    # no unsigned #
# upb_count = 45      # find 45 mprimes if int was given enough bits #
upb_count = 15      # find 45 mprimes if int was given enough bits #

print (" Finding Mersenne primes in M[2..%d]:"%upb_prime)

count=0
# for p in range(2, upb_prime+1):
for p in range(2, int(upb_prime+1)):
  if lucas_lehmer_fast(p):
    print("M%d"%p),
    stdout.flush()
    count += 1
  if count >= upb_count: break
print
