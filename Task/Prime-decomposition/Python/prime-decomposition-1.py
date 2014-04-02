from __future__ import print_function

import sys
from itertools import islice, cycle, count

try:
    from itertools import compress
except ImportError:
    def compress(data, selectors):
        """compress('ABCDEF', [1,0,1,0,1,1]) --> A C E F"""
        return (d for d, s in zip(data, selectors) if s)


def is_prime(n):
    return list(zip((True, False), decompose(n)))[-1][0]

class IsPrimeCached(dict):
    def __missing__(self, n):
        r = is_prime(n)
        self[n] = r
        return r

is_prime_cached = IsPrimeCached()

def croft():
    """Yield prime integers using the Croft Spiral sieve.

    This is a variant of wheel factorisation modulo 30.
    """
    # Copied from:
    #   https://code.google.com/p/pyprimes/source/browse/src/pyprimes.py
    # Implementation is based on erat3 from here:
    #   http://stackoverflow.com/q/2211990
    # and this website:
    #   http://www.primesdemystified.com/
    # Memory usage increases roughly linearly with the number of primes seen.
    # dict ``roots`` stores an entry x:p for every prime p.
    for p in (2, 3, 5):
        yield p
    roots = {9: 3, 25: 5}  # Map d**2 -> d.
    primeroots = frozenset((1, 7, 11, 13, 17, 19, 23, 29))
    selectors = (1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0)
    for q in compress(
            # Iterate over prime candidates 7, 9, 11, 13, ...
            islice(count(7), 0, None, 2),
            # Mask out those that can't possibly be prime.
            cycle(selectors)
            ):
        # Using dict membership testing instead of pop gives a
        # 5-10% speedup over the first three million primes.
        if q in roots:
            p = roots[q]
            del roots[q]
            x = q + 2*p
            while x in roots or (x % 30) not in primeroots:
                x += 2*p
            roots[x] = p
        else:
            roots[q*q] = q
            yield q
primes = croft

def decompose(n):
    for p in primes():
        if p*p > n: break
        while n % p == 0:
            yield p
            n //=p
    if n > 1:
        yield n


if __name__ == '__main__':
    # Example: calculate factors of Mersenne numbers to M59 #

    import time

    for m in primes():
        p = 2 ** m - 1
        print( "2**{0:d}-1 = {1:d}, with factors:".format(m, p) )
        start = time.time()
        for factor in decompose(p):
            print(factor, end=' ')
            sys.stdout.flush()

        print( "=> {0:.2f}s".format( time.time()-start ) )
        if m >= 59:
            break
