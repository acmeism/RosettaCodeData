'''Babbage problem'''

from math import (floor, sqrt)
from itertools import (islice)


# squaresWithSuffix :: Int -> Gen [Int]
def squaresWithSuffix(n):
    '''Non finite stream of squares with a given suffix.'''
    stem = 10 ** len(str(n))
    i = 0
    while True:
        i = until(lambda x: isPerfectSquare(n + (stem * x)))(
            succ
        )(i)
        yield n + (stem * i)
        i = succ(i)


# isPerfectSquare :: Int -> Bool
def isPerfectSquare(n):
    '''True if n is a perfect square.'''
    r = sqrt(n)
    return r == floor(r)


# TEST ----------------------------------------------------

# main :: IO ()
def main():
    '''Smallest positive integers whose squares end in the digits 269,696'''
    print(
        fTable(main.__doc__ + ':\n')(
            lambda n: str(int(sqrt(n))) + '^2'
        )(repr)(identity)(
            take(10)(squaresWithSuffix(269696))
        )
    )


# GENERIC -------------------------------------------------

# identity :: a -> a
def identity(x):
    '''The identity function.'''
    return x


# succ :: Enum a => a -> a
def succ(x):
    '''The successor of a value.
       For numeric types, (1 +).
    '''
    return 1 + x if isinstance(x, int) else (
        chr(1 + ord(x))
    )


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


# FORMATTING ----------------------------------------------
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


# MAIN ---
if __name__ == '__main__':
    main()
