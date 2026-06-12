""" rosettacode.orgwiki/Wolstenholme_numbers """

from fractions import Fraction
from itertools import accumulate
from gmpy2 import is_prime


def wolstenholme(k):
    """ Get the first k Wolstenholme numbers """
    return [r.numerator
            for r in accumulate((Fraction(1, i*i) for i in range(1, k+1)), lambda x, y: x+y)]


def abbreviated(wstr, thresh=60, term='digits'):
    """ return an abbreviated string with beginning / end and actual number of chars """
    i, wlen = max(thresh // 2, 5), len(wstr)
    return wstr if wlen < thresh else ' '.join([wstr[:i], '...', wstr[-i-1:], str(wlen), term])


def process_wolstenholmes():
    """ Run the tasks at rosettacode.org/wiki/Wolstenholme_numbers """
    wols = wolstenholme(10000)
    print('Wolstenholme numbers 1 through 20, 500, 1000, 2500, 5000, 10000:')
    for i in list(range(1, 21)) + [500, 1000, 2500, 5000, 10000]:
        print(f'{i:5d}: {abbreviated(str(wols[i-1]))}')
    print('\nFifteen Wolstenholme primes:')
    for i, num in enumerate(filter(is_prime, wols[:2000])):
        print(f'{i+1:2d}: {abbreviated(str(num))}')


process_wolstenholmes()
