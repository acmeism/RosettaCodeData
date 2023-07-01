'''Proper divisors'''

from itertools import accumulate, chain, groupby, product
from functools import reduce
from math import floor, sqrt
from operator import mul


# properDivisors :: Int -> [Int]
def properDivisors(n):
    '''The ordered divisors of n, excluding n itself.
    '''
    def go(a, group):
        return [x * y for x, y in product(
            a,
            accumulate(chain([1], group), mul)
        )]
    return sorted(
        reduce(go, [
            list(g) for _, g in groupby(primeFactors(n))
        ], [1])
    )[:-1] if 1 < n else []


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Tests'''

    print(
        fTable('Proper divisors of [1..10]:')(str)(str)(
            properDivisors
        )(range(1, 1 + 10))
    )

    print('\nExample of maximum divisor count in the range [1..20000]:')
    print(
        max(
            [(n, len(properDivisors(n))) for n in range(1, 1 + 20000)],
            key=snd
        )
    )


# -------------------------DISPLAY-------------------------

# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
       f -> xs -> tabular string.
    '''
    def go(xShow, fxShow, f, xs):
        ys = [xShow(x) for x in xs]
        w = max(map(len, ys))
        return s + '\n' + '\n'.join(map(
            lambda x, y: y.rjust(w, ' ') + ' -> ' + fxShow(f(x)),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# -------------------------GENERIC-------------------------

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


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


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
