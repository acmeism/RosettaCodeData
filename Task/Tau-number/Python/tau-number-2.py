'''Tau numbers'''

from operator import mul
from math import floor, sqrt
from functools import reduce
from itertools import (
    accumulate, chain, count,
    groupby, islice, product
)


# tauNumbers :: Generator [Int]
def tauNumbers():
    '''Positive integers divisible by the
       count of their positive divisors.
    '''
    return (
        n for n in count(1)
        if 0 == n % len(divisors(n))
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''The first hundred Tau numbers.
    '''
    xs = take(100)(
        tauNumbers()
    )
    w = len(str(xs[-1]))
    print('\n'.join([
        ' '.join([
            str(cell).rjust(w, ' ') for cell in row
        ])
        for row in chunksOf(10)(xs)
    ]))


# ----------------------- GENERIC ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    def go(xs):
        return (
            xs[i:n + i] for i in range(0, len(xs), n)
        ) if 0 < n else None
    return go


# divisors :: Int -> [Int]
def divisors(n):
    '''The ordered divisors of n.
    '''
    def go(a, x):
        return [a * b for a, b in product(
            a,
            accumulate(chain([1], x), mul)
        )]
    return sorted(
        reduce(go, [
            list(g) for _, g
            in groupby(primeFactors(n))
        ], [1])
    ) if 1 < n else [1]


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
    def go(xs):
        return (
            xs[0:n]
            if isinstance(xs, (list, tuple))
            else list(islice(xs, n))
        )
    return go


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f):
        def g(x):
            v = x
            while not p(v):
                v = f(v)
            return v
        return g
    return go


# MAIN ---
if __name__ == '__main__':
    main()
