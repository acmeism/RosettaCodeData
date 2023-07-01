from __future__ import print_function
from prime_decomposition import primes
from itertools import islice


def p_range(lower_inclusive, upper_exclusive):
    'Primes in the range'
    for p in primes():
        if p >= upper_exclusive: break
        if p >= lower_inclusive: yield p

if __name__ == '__main__':
    print('The first twenty primes:\n  ', list(islice(primes(),20)))
    print('The primes between 100 and 150:\n  ', list(p_range(100, 150)))
    print('The ''number'' of primes between 7,700 and 8,000:\n  ', len(list(p_range(7700, 8000))))
    print('The 10,000th prime:\n  ', next(islice(primes(),10000-1, 10000)))
