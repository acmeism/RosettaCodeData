'''Sequence of non-squares'''

from itertools import count, islice
from math import floor, sqrt


# A000037 :: [Int]
def A000037():
    '''A non-finite series of integers.'''
    return map(nonSquare, count(1))


# nonSquare :: Int -> Int
def nonSquare(n):
    '''Nth term in the OEIS A000037 series.'''
    return n + floor(1 / 2 + sqrt(n))


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''OEIS A000037'''

    def first22():
        '''First 22 terms'''
        return take(22)(A000037())

    def squareInFirstMillion():
        '''True if any of the first 10^6 terms are perfect squares'''
        return any(map(
            isPerfectSquare,
            take(10 ** 6)(A000037())
        ))

    print(
        fTable(main.__doc__)(
            lambda f: '\n' + f.__doc__
        )(lambda x: '    ' + showList(x))(
            lambda f: f()
        )([first22, squareInFirstMillion])
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
        return s + '\n' + '\n'.join(map(
            lambda x, y: y + ':\n' + fxShow(f(x)),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# -------------------------GENERAL-------------------------

# isPerfectSquare :: Int -> Bool
def isPerfectSquare(n):
    '''True if n is a perfect square.'''
    return sqrt(n).is_integer()


# showList :: [a] -> String
def showList(xs):
    '''Compact stringification of any list value.'''
    return '[' + ','.join(repr(x) for x in xs) + ']' if (
        isinstance(xs, list)
    ) else repr(xs)


# take :: Int -> [a] -> [a]
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: list(islice(xs, n))


# MAIN ---
if __name__ == '__main__':
    main()
