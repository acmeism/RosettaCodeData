'''Esthetic numbers'''

from functools import reduce
from itertools import (
    accumulate, chain, count, dropwhile,
    islice, product, takewhile
)
from operator import add
from string import digits, ascii_lowercase
from textwrap import wrap


# estheticNumbersInBase :: Int -> [Int]
def estheticNumbersInBase(b):
    '''Infinite stream of numbers which are
       esthetic in a given base.
    '''
    return concatMap(
        compose(
            lambda deltas: concatMap(
                lambda headDigit: concatMap(
                    compose(
                        fromBaseDigits(b),
                        scanl(add)(headDigit)
                    )
                )(deltas)
            )(range(1, b)),
            replicateList([-1, 1])
        )
    )(count(0))


# ------------------------ TESTS -------------------------
def main():
    '''Specified tests'''
    def samples(b):
        i, j = b * 4, b * 6
        return '\n'.join([
            f'Esthetics [{i}..{j}] for base {b}:',
            unlines(wrap(
                unwords([
                    showInBase(b)(n) for n in compose(
                        drop(i - 1), take(j)
                    )(
                        estheticNumbersInBase(b)
                    )
                ]), 60
            ))
        ])

    def takeInRange(a, b):
        return compose(
            dropWhile(lambda x: x < a),
            takeWhile(lambda x: x <= b)
        )

    print(
        '\n\n'.join([
            samples(b) for b in range(2, 1 + 16)
        ])
    )
    for (lo, hi) in [(1000, 9999), (100_000_000, 130_000_000)]:
        print(f'\nBase 10 Esthetics in range [{lo}..{hi}]:')
        print(
            unlines(wrap(
                unwords(
                    str(x) for x in takeInRange(lo, hi)(
                        estheticNumbersInBase(10)
                    )
                ), 60
            ))
        )


# ------------------- BASES AND DIGITS -------------------

# fromBaseDigits :: Int -> [Int] -> [Int]
def fromBaseDigits(b):
    '''An empty list if any digits are out of range for
       the base. Otherwise a list containing an integer.
    '''
    def go(digitList):
        maybeNum = reduce(
            lambda r, d: None if r is None or (
                0 > d or d >= b
            ) else r * b + d,
            digitList, 0
        )
        return [] if None is maybeNum else [maybeNum]
    return go


# toBaseDigits :: Int -> Int -> [Int]
def toBaseDigits(b):
    '''A list of the digits of n in base b.
    '''
    def f(x):
        return None if 0 == x else (
            divmod(x, b)[::-1]
        )
    return lambda n: list(reversed(unfoldr(f)(n)))


# showInBase :: Int -> Int -> String
def showInBase(b):
    '''String representation of n in base b.
    '''
    charSet = digits + ascii_lowercase
    return lambda n: ''.join([
        charSet[i] for i in toBaseDigits(b)(n)
    ])


# ----------------------- GENERIC ------------------------

# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    def go(f, g):
        def fg(x):
            return f(g(x))
        return fg
    return reduce(go, fs, lambda x: x)


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been
       mapped.
       The list monad can be derived by using a function f
       which wraps its output in a list, (using an empty
       list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


# drop :: Int -> [a] -> [a]
# drop :: Int -> String -> String
def drop(n):
    '''The sublist of xs beginning at
       (zero-based) index n.
    '''
    def go(xs):
        if isinstance(xs, (list, tuple, str)):
            return xs[n:]
        else:
            take(n)(xs)
            return xs
    return go


# dropWhile :: (a -> Bool) -> [a] -> [a]
# dropWhile :: (Char -> Bool) -> String -> String
def dropWhile(p):
    '''The suffix remainining after takeWhile p xs.
    '''
    return lambda xs: list(
        dropwhile(p, xs)
    )


# replicateList :: [a] -> Int -> [[a]]
def replicateList(xs):
    '''All distinct lists of length n that
       consist of elements drawn from xs.
    '''
    def rep(n):
        def go(x):
            return [[]] if 1 > x else [
                ([a] + b) for (a, b) in product(
                    xs, go(x - 1)
                )
            ]
        return go(n)
    return rep


# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but defines a succession of
       intermediate values, building from the left.
    '''
    def go(a):
        def g(xs):
            return accumulate(chain([a], xs), f)
        return g
    return go


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    def go(xs):
        return list(islice(xs, n))
    return go


# takeWhile :: (a -> Bool) -> [a] -> [a]
# takeWhile :: (Char -> Bool) -> String -> String
def takeWhile(p):
    '''The longest (possibly empty) prefix of xs
       in which all elements satisfy p.
    '''
    return lambda xs: list(
        takewhile(p, xs)
    )


# unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
def unfoldr(f):
    '''Dual to reduce or foldr.
       Where catamorphism reduces a list to a summary value,
       the anamorphic unfoldr builds a list from a seed value.
       As long as f returns (a, b) a is prepended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns None, the completed list is returned.
    '''
    def go(v):
        xr = v, v
        xs = []
        while True:
            xr = f(xr[1])
            if None is not xr:
                xs.append(xr[0])
            else:
                return xs
    return go


# unlines :: [String] -> String
def unlines(xs):
    '''A single string formed by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# unwords :: [String] -> String
def unwords(xs):
    '''A space-separated string derived
       from a list of words.
    '''
    return ' '.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
