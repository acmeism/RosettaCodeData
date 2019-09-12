"""Left factorials"""

from itertools import (accumulate, chain, count, islice)
from operator import (mul, add)


# leftFact :: [Integer]
def leftFact():
    '''Left factorial series defined in terms of the factorial series'''
    return scanl(add)(0)(
        fact()
    )


# fact :: [Integer]
def fact():
    '''Factorial series – a non-finite list'''
    return scanl(mul)(1)(
        enumFrom(1)
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tests'''
    print(
        'Terms 0 thru 10 inclusive:\n  %r'
        % take(11)(leftFact())
    )

    print('\nTerms 20 thru 110 (inclusive) by tens:')
    for x in takeFromThenTo(20)(30)(110)(leftFact()):
        print(x)

    print(
        '\n\nDigit counts for terms 1k through 10k (inclusive) by k:\n  %r'
        % list(map(
            compose(len)(str),
            takeFromThenTo(1000)(2000)(10000)(
                leftFact()
            )
        ))
    )


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Function composition.'''
    return lambda f: lambda x: g(f(x))


# enumFrom :: Enum a => a -> [a]
def enumFrom(x):
    '''A non-finite stream of enumerable values,
       starting from the given value.'''
    return count(x) if isinstance(x, int) else (
        map(chr, count(ord(x)))
    )


# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but returns a succession of
       intermediate values, building from the left.'''
    return lambda a: lambda xs: (
        accumulate(chain([a], xs), f)
    )


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else list(islice(xs, n))
    )


# takeFromThenTo :: Int -> Int -> Int -> [a] -> [a]
def takeFromThenTo(a):
    '''Values drawn from a series betweens positions a and b
       at intervals of size z'''
    return lambda b: lambda z: lambda xs: islice(
        xs, a, 1 + z, b - a
    )


if __name__ == '__main__':
    main()
