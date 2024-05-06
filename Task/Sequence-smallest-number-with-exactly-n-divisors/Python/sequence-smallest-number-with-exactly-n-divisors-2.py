'''Smallest number with exactly n divisors'''

from itertools import accumulate, chain, count, groupby, islice, product
from functools import reduce
from math import sqrt, floor
from operator import mul


# a005179 :: () -> [Int]
def a005179():
    '''Integer sequence: smallest number with exactly n divisors.'''
    return (
        next(
            x for x in count(1)
            if n == 1 + len(properDivisors(x))
        ) for n in count(1)
    )


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''First 15 terms of a005179'''
    print(main.__doc__ + ':\n')
    print(
        take(15)(
            a005179()
        )
    )


# -------------------------GENERIC-------------------------

# properDivisors :: Int -> [Int]
def properDivisors(n):
    '''The ordered divisors of n, excluding n itself.
    '''
    def go(a, x):
        return [a * b for a, b in product(
            a,
            accumulate(chain([1], x), mul)
        )]
    return sorted(
        reduce(go, [
            list(g) for _, g in groupby(primeFactors(n))
        ], [1])
    )[:-1] if 1 < n else []


# primeFactors :: Int -> [Int]
def primeFactors(n):
    '''A list of the prime factors of n.
    '''
    def f(qr):
        r = qr[1]
        return step(r), 1 + r

    def step(x):
        return 1 + (x << 2) - ((x >> 1) << 1)

    def go(x):
        root = floor(sqrt(x))

        def p(qr):
            q = qr[0]
            return root < q or 0 == (x % q)

        q = until(p)(f)(
            (2 if 0 == x % 2 else 3, 1)
        )[0]
        return [x] if q > root else [q] + go(x // q)

    return go(n)


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
    )


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


# MAIN ---
if __name__ == '__main__':
    main()
