'''Attractive numbers'''

from itertools import chain, count, takewhile
from functools import reduce


# attractiveNumbers :: () -> [Int]
def attractiveNumbers():
    '''A non-finite stream of attractive numbers.
       (OEIS A063989)
    '''
    return filter(
        compose(
            isPrime,
            len,
            primeDecomposition
        ),
        count(1)
    )


# TEST ----------------------------------------------------
def main():
    '''Attractive numbers drawn from the range [1..120]'''
    for row in chunksOf(15)(list(
            takewhile(
                lambda x: 120 >= x,
                attractiveNumbers()
            )
    )):
        print(' '.join(map(
            compose(justifyRight(3)(' '), str),
            row
        )))


# GENERAL FUNCTIONS ---------------------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    return lambda x: reduce(
        lambda a, f: f(a),
        fs[::-1], x
    )


# We only need light implementations
# of prime functions here:

# primeDecomposition :: Int -> [Int]
def primeDecomposition(n):
    '''List of integers representing the
       prime decomposition of n.
    '''
    def go(n, p):
        return [p] + go(n // p, p) if (
            0 == n % p
        ) else []
    return list(chain.from_iterable(map(
        lambda p: go(n, p) if isPrime(p) else [],
        range(2, 1 + n)
    )))


# isPrime :: Int -> Bool
def isPrime(n):
    '''True if n is prime.'''
    if n in (2, 3):
        return True
    if 2 > n or 0 == n % 2:
        return False
    if 9 > n:
        return True
    if 0 == n % 3:
        return False

    return not any(map(
        lambda x: 0 == n % x or 0 == n % (2 + x),
        range(5, 1 + int(n ** 0.5), 6)
    ))


# justifyRight :: Int -> Char -> String -> String
def justifyRight(n):
    '''A string padded at left to length n,
       using the padding character c.
    '''
    return lambda c: lambda s: s.rjust(n, c)


# MAIN ---
if __name__ == '__main__':
    main()
