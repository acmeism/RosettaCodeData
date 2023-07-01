'''Farey sequence'''

from itertools import (chain, count, islice)
from math import gcd


# farey :: Int -> [Ratio Int]
def farey(n):
    '''Farey sequence of order n.'''
    return sorted(
        nubBy(on(eq)(fromRatio))(
            bind(enumFromTo(1)(n))(
                lambda k: bind(enumFromTo(0)(k))(
                    lambda m: [ratio(m)(k)]
                )
            )
        ),
        key=fromRatio
    ) + [ratio(1)(1)]


# fareyLength :: Int -> Int
def fareyLength(n):
    '''Number of terms in a Farey sequence
       of order n.'''
    def go(x):
        return (x * (x + 3)) // 2 - sum(
            go(x // k) for k in enumFromTo(2)(x)
        )
    return go(n)


# showFarey :: [Ratio Int] -> String
def showFarey(xs):
    '''Stringification of a Farey sequence.'''
    return '(' + ', '.join(map(showRatio, xs)) + ')'


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tests'''

    print(
        fTable(
            'Farey sequence for orders 1-11 (inclusive):\n'
        )(str)(showFarey)(
            farey
        )(enumFromTo(1)(11))
    )
    print(
        fTable(
            '\n\nNumber of fractions in the Farey sequence ' +
            'for order 100 through 1,000 (inclusive) by hundreds:\n'
        )(str)(str)(
            fareyLength
        )(enumFromThenTo(100)(200)(1000))
    )


# GENERIC -------------------------------------------------

# bind(>>=) :: [a] -> (a -> [b]) -> [b]
def bind(xs):
    '''List monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.'''
    return lambda f: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# enumFromThenTo :: Int -> Int -> Int -> [Int]
def enumFromThenTo(m):
    '''Integer values enumerated from m to n
       with a step defined by nxt-m.
    '''
    def go(nxt, n):
        d = nxt - m
        return islice(count(0), m, d + n, d)
    return lambda nxt: lambda n: (
        list(go(nxt, n))
    )


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# eq (==) :: Eq a => a -> a -> Bool
def eq(a):
    '''Simple equality of a and b.'''
    return lambda b: a == b


# fromRatio :: Ratio Int -> Float
def fromRatio(r):
    '''A floating point value derived from a
       a rational value.
    '''
    return r.get('numerator') / r.get('denominator')


# nubBy :: (a -> a -> Bool) -> [a] -> [a]
def nubBy(p):
    '''A sublist of xs from which all duplicates,
       (as defined by the equality predicate p)
       are excluded.
    '''
    def go(xs):
        if not xs:
            return []
        x = xs[0]
        return [x] + go(
            list(filter(
                lambda y: not p(x)(y),
                xs[1:]
            ))
        )
    return lambda xs: go(xs)


# on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
def on(f):
    '''A function returning the value of applying
      the binary f to g(a) g(b)
    '''
    return lambda g: lambda a: lambda b: f(g(a))(g(b))


# ratio :: Int -> Int -> Ratio Int
def ratio(n):
    '''Rational value constructed
       from a numerator and a denominator.
    '''
    def go(n, d):
        g = gcd(n, d)
        return {
            'type': 'Ratio',
            'numerator': n // g, 'denominator': d // g
        }
    return lambda d: go(n * signum(d), abs(d))


# showRatio :: Ratio -> String
def showRatio(r):
    '''String representation of the ratio r.'''
    d = r.get('denominator')
    return str(r.get('numerator')) + (
        '/' + str(d) if 1 != d else ''
    )


# signum :: Num -> Num
def signum(n):
    '''The sign of n.'''
    return -1 if 0 > n else (1 if 0 < n else 0)


# fTable :: String -> (a -> String) ->
#                     (b -> String) -> (a -> b) -> [a] -> String
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


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


if __name__ == '__main__':
    main()
