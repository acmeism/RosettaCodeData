'''Nth Fibonacci term (by folding)'''

from functools import reduce
from operator import add


# nthFib :: Integer -> Integer
def nthFib(n):
    '''Nth integer in the Fibonacci series.'''
    def go(ab, _):
        return ab[1], add(*ab)
    return reduce(go, range(1, n), (0, 1))[1]


# MAIN ---
if __name__ == '__main__':
    print(
        '1000th term: ' + repr(
            nthFib(1000)
        )
    )
