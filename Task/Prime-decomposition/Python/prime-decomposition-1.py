from __future__ import print_function

import sys
from itertools import cycle

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
    roots = {}  # Map x*d -> 2*d.
    not_primeroot = tuple(x not in {1,7,11,13,17,19,23,29} for x in range(30))
    q = 1
    for x in cycle((6, 4, 2, 4, 2, 4, 6, 2)):
        # Iterate over prime candidates 7, 11, 13, 17, ...
        q += x
        # Using dict membership testing instead of pop gives a
        # 5-10% speedup over the first three million primes.
        if q in roots:
            p = roots.pop(q)
            x = q + p
            while not_primeroot[x % 30] or x in roots:
                x += p
            roots[x] = p
        else:
            roots[q * q] = q + q
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
