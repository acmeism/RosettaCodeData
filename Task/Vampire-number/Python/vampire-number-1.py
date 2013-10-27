import math
from operator import mul
from itertools import product
from functools import reduce


def fac(n):
    '''\
    return the prime factors for n
    >>> fac(600)
    [5, 5, 3, 2, 2, 2]
    >>> fac(1000)
    [5, 5, 5, 2, 2, 2]
    >>>
    '''
    step = lambda x: 1 + x*4 - (x//2)*2
    maxq = int(math.floor(math.sqrt(n)))
    d = 1
    q = n % 2 == 0 and 2 or 3
    while q <= maxq and n % q != 0:
        q = step(d)
        d += 1
    res = []
    if q <= maxq:
        res.extend(fac(n//q))
        res.extend(fac(q))
    else: res=[n]
    return res

def fact(n):
    '''\
    return the prime factors and their multiplicities for n
    >>> fact(600)
    [(2, 3), (3, 1), (5, 2)]
    >>> fact(1000)
    [(2, 3), (5, 3)]
    >>>
    '''
    res = fac(n)
    return [(c, res.count(c)) for c in set(res)]

def divisors(n):
    'Returns all the divisors of n'
    factors = fact(n)   # [(primefactor, multiplicity), ...]
    primes, maxpowers = zip(*factors)
    powerranges = (range(m+1) for m in maxpowers)
    powers = product(*powerranges)
    return (
        reduce(mul,
               (prime**power for prime, power in zip(primes, powergroup)),
               1)
        for powergroup in powers)

def vampire(n):
    fangsets = set( frozenset([d, n//d])
                    for d in divisors(n)
                    if (len(str(d)) == len(str(n))/2
                        and sorted(str(d) + str(n//d)) == sorted(str(n))
                        and (str(d)[-1] == 0) + (str(n//d)[-1] == 0) <=1) )
    return sorted(tuple(sorted(fangs)) for fangs in fangsets)


if __name__ == '__main__':
    print('First 25 vampire numbers')
    count = n = 0
    while count <25:
        n += 1
        fangpairs = vampire(n)
        if fangpairs:
            count += 1
            print('%i: %r' % (n, fangpairs))
    print('\nSpecific checks for fangpairs')
    for n in (16758243290880, 24959017348650, 14593825548650):
        fangpairs = vampire(n)
        print('%i: %r' % (n, fangpairs))
