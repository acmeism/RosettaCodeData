from math import gcd
from functools import lru_cache
from itertools import islice, count

@lru_cache(maxsize=None)
def  φ(n):
    return sum(1 for k in range(1, n + 1) if gcd(n, k) == 1)

def perfect_totient():
    for n0 in count(1):
        parts, n = 0, n0
        while n != 1:
            n = φ(n)
            parts += n
        if parts == n0:
            yield n0


if __name__ == '__main__':
    print(list(islice(perfect_totient(), 20)))
