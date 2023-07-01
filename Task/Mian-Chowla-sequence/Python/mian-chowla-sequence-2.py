'''Mian-Chowla series'''

from itertools import (islice)
from time import time


# mianChowlas :: Gen [Int]
def mianChowlas():
    '''Mian-Chowla series - Generator constructor
    '''
    mcs = [1]
    sumSet = set([2])
    x = 1
    while True:
        yield x
        (sumSet, mcs, x) = nextMC(sumSet, mcs, x)


# nextMC :: (Set Int, [Int], Int) -> (Set Int, [Int], Int)
def nextMC(setSums, mcs, n):
    '''(Set of sums, series so far, current term) ->
        (updated sum set, updated series, next term)
    '''
    def valid(x):
        for m in mcs:
            if x + m in setSums:
                return False
        return True

    x = until(valid)(succ)(n)
    setSums.update(
        [x + y for y in mcs] + [2 * x]
    )
    return (setSums, mcs + [x], x)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tests'''

    start = time()
    genMianChowlas = mianChowlas()
    print(
        'First 30 terms of the Mian-Chowla series:\n',
        take(30)(genMianChowlas)
    )
    drop(60)(genMianChowlas)
    print(
        '\n\nTerms 91 to 100 of the Mian-Chowla series:\n',
        take(10)(genMianChowlas),
        '\n'
    )
    print(
        '(Computation time c. ' + str(round(
            1000 * (time() - start)
        )) + ' ms)'
    )


# GENERIC -------------------------------------------------

# drop :: Int -> [a] -> [a]
# drop :: Int -> String -> String
def drop(n):
    '''The suffix of xs after the
       first n elements, or [] if n > length xs'''
    def go(xs):
        if isinstance(xs, list):
            return xs[n:]
        else:
            take(n)(xs)
            return xs
    return lambda xs: go(xs)


# succ :: Int -> Int
def succ(x):
    '''The successor of a numeric value (1 +)'''
    return 1 + x


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else list(islice(xs, n))
    )


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of applying f until p holds.
       The initial seed value is x.'''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


if __name__ == '__main__':
    main()
