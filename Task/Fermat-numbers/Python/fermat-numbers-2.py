'''Fermat numbers'''

from itertools import count, islice
from math import floor, sqrt


# fermat :: Int -> Int
def fermat(n):
    '''Nth Fermat number.
       Nth term of OEIS A000215.
    '''
    return 1 + (2 ** (2 ** n))


# fermats :: () -> [Int]
def fermats():
    '''Non-finite series of Fermat numbers.
       OEIS A000215.
    '''
    return (fermat(x) for x in enumFrom(0))


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''First 10 Fermats, and factors of first 7.'''

    print(
        fTable('First ten Fermat numbers:')(str)(str)(
            fermat
        )(enumFromTo(0)(9))
    )

    print(
        fTable('\n\nFactors of first seven:')(str)(
            lambda xs: repr(xs) if 1 < len(xs) else '(prime)'
        )(primeFactors)(
            take(7)(fermats())
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

# enumFrom :: Enum a => a -> [a]
def enumFrom(x):
    '''A non-finite stream of enumerable values,
       starting from the given value.
    '''
    return count(x) if isinstance(x, int) else (
        map(chr, count(ord(x)))
    )


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    def go(n):
        return list(range(m, 1 + n))
    return lambda n: go(n)


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
