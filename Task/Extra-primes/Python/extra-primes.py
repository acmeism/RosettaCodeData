from itertools import *
from functools import reduce

class Sieve(object):
    """Sieve of Eratosthenes"""
    def __init__(self):
        self._primes = []
        self._comps = {}
        self._max = 2;

    def isprime(self, n):
        """check if number is prime"""
        if n >= self._max: self._genprimes(n)
        return n >= 2 and n in self._primes

    def _genprimes(self, max):
        while self._max <= max:
            if self._max not in self._comps:
                self._primes.append(self._max)
                self._comps[self._max*self._max] = [self._max]
            else:
                for p in self._comps[self._max]:
                    ps = self._comps.setdefault(self._max+p, [])
                    ps.append(p)
                del self._comps[self._max]
            self._max += 1

def extra_primes():
    """Successively generate all extra primes."""
    d = [2,3,5,7]
    s = Sieve()
    for cand in chain.from_iterable(product(d, repeat=r) for r in count(1)):
        num = reduce(lambda x, y: x*10+y, cand)
        if s.isprime(num) and s.isprime(sum(cand)): yield num

for n in takewhile(lambda n: n < 10000, extra_primes()):
    print(n)
