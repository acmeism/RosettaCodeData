"""Cellular Automata"""

from itertools import (islice, repeat)
from random import randint


# ruleSample :: Int -> String
def ruleSample(intRule):
    '''16 steps in the evolution of a specified Wolfram rule.'''
    return 'Rule ' + str(intRule) + ':\n' + (
        unlines(map(
            showCells,
            take(16)(
                iterate(nextRowByRule(intRule))(
                    onePixelInLineOf(64) if bool(randint(0, 1)) else (
                        randomPixelsInLineOf(64)
                    )
                )
            )
        ))
    )


# nextRowByRule :: Int -> [Bool] -> [Bool]
def nextRowByRule(intRule):
    '''A row of booleans derived by Wolfram rule n
       from another boolean row of the same length.'''

    # step :: (Bool, Bool, Bool) -> Bool
    def step(l, x, r):
        return bool(intRule & 2**intFromBools([l, x, r]))

    # go :: [Bool] -> Bool
    def go(xs):
        return [False] + list(map(
            step,
            xs, xs[1:], xs[2:]
        )) + [False]
    return lambda xs: go(xs)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Samples of Wolfram rule evolutions.'''

    print(
        unlines(map(ruleSample, [104, 30, 110]))
    )


# boolsFromInt :: Int -> [Bool]
def boolsFromInt(n):
    '''List of booleans derived by binary
       decomposition of an integer.'''
    def go(x):
        return Just((x // 2, bool(x % 2))) if x else Nothing()
    return unfoldl(go)(n)


# intFromBools :: [Bool] -> Int
def intFromBools(xs):
    '''Integer derived by binary interpretation
       of a list of booleans.'''
    def go(b, pn):
        power, n = pn
        return (2 * power, n + power if b else n)
    return foldr(go)([1, 0])(xs)[1]


# nBoolsFromInt :: Int -> Int -> [Bool]
def nBoolsFromInt(n):
    '''List of bools, left-padded to given length n,
       derived by binary decomposition of an integer x.'''
    def go(n, x):
        bs = boolsFromInt(x)
        return list(repeat(False, n - len(bs))) + bs
    return lambda x: go(n, x)


# onePixelInLineOf :: Int -> [Bool]
def onePixelInLineOf(n):
    '''A row of n (mainly False) booleans,
       with a single True value in the middle.'''
    return nBoolsFromInt(n)(
        2**(n // 2)
    )


# randomPixelsInLineOf :: Int -> [Bool]
def randomPixelsInLineOf(n):
    '''A row of n booleans with pseudorandom values.'''
    return [bool(randint(0, 1)) for _ in range(1, 1 + n)]


# showCells :: [Bool] -> String
def showCells(xs):
    '''A block string representation of a list of booleans.'''
    return ''.join([chr(9608) if x else ' ' for x in xs])


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# foldr :: (a -> b -> b) -> b -> [a] -> b
def foldr(f):
    '''Right to left reduction of a list,
       using a binary operator.'''
    def go(v, xs):
        a = v
        for x in xs:
            a = f(x, a)
        return a
    return lambda acc: lambda xs: go(acc, xs[::-1])


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated applications of f to x.'''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return lambda x: go(x)


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


# unfoldl(lambda x: Just(((x - 1), x)) if 0 != x else Nothing())(10)
# -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
def unfoldl(f):
    '''Dual to reduce or foldl.
       Where these reduce a list to a summary value, unfoldl
       builds a list from a seed value.
       Where f returns Just(a, b), a is appended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns Nothing, the completed list is returned.'''
    def go(v):
        xr = v, v
        xs = []
        while True:
            mb = f(xr[0])
            if mb.get('Nothing'):
                return xs
            else:
                xr = mb.get('Just')
                xs.insert(0, xr[1])
        return xs
    return lambda x: go(x)


# unlines :: [String] -> String
def unlines(xs):
    '''A single newline-delimited string derived
       from a list of strings.'''
    return '\n'.join(xs)


# MAIN -------------------------------------------------
if __name__ == '__main__':
    main()
