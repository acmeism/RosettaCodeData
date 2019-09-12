from operator import mul
from functools import reduce


def comb(n,r):
    ''' calculate nCr - the binomial coefficient
    >>> comb(3,2)
    3
    >>> comb(9,4)
    126
    >>> comb(9,6)
    84
    >>> comb(20,14)
    38760
    '''

    if r > n-r:
        # r = n-r   for smaller intermediate values during computation
        return ( reduce( mul, range((n - (n-r) + 1), n + 1), 1)
                 // reduce( mul, range(1, (n-r) + 1), 1) )
    else:
        return ( reduce( mul, range((n - r + 1), n + 1), 1)
                 // reduce( mul, range(1, r + 1), 1) )
