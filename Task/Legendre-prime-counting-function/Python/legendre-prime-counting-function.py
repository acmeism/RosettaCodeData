from primesieve import primes
from math import isqrt
from functools import cache

p = primes(isqrt(1_000_000_000))

@cache
def phi(x, a):
    res = 0
    while True:
        if not a or not x:
            return x + res

        a -= 1
        res -= phi(x//p[a], a) # partial tail recursion

def legpi(n):
    if n < 2: return 0

    a = legpi(isqrt(n))
    return phi(n, a) + a - 1

for e in range(10):
    print(f'10^{e}', legpi(10**e))
