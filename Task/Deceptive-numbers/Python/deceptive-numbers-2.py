from itertools import accumulate, cycle, islice
from math import isqrt

primes = []
wheel = 4, 2, 4, 2, 4, 6, 2, 6

def is_pseudo(n):
    if pow(10, n - 1, n) == 1:
        s = isqrt(n)
        for p in primes:
            if p > s: break
            if n % p == 0: return True
        primes.append(n)
    return False

print(*islice(filter(is_pseudo, accumulate(cycle(wheel), initial=7)), 100))
