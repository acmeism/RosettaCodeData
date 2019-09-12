'''Nth Fibonacci term (by folding)'''

from functools import (reduce)


# nthFib :: Integer -> Integer
def nthFib(n):
    '''Nth integer in the Fibonacci series.'''
    def go(ab, _):
        a, b = ab
        return (b, a + b)
    return reduce(go, range(1, n), (0, 1))[1]


# MAIN ---
if __name__ == '__main__':
    print(
        '1000th term: ' + repr(
            nthFib(1000)
        )
    )
