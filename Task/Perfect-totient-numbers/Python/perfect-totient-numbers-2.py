'''Perfect totient numbers'''

from functools import lru_cache
from itertools import count, islice
from math import gcd
import operator


# perfectTotients :: () -> [Int]
def perfectTotients():
    '''An unbounded sequence of perfect totients.
       OEIS A082897
    '''
    def p(x):
        return x == 1 + sum(
            iterateUntil(eq(1))(
                phi
            )(x)[1:]
        )
    return filter(p, count(2))


@lru_cache(maxsize=None)
def phi(n):
    '''Euler's totient function.
       The count of integers up to n which
       are relatively prime to n.
    '''
    return len([
        x for x in enumFromTo(1)(n)
        if 1 == gcd(n, x)
    ])


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''First twenty perfect totient numbers'''
    print(
        take(20)(
            perfectTotients()
        )
    )


# GENERIC -------------------------------------------------

# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.
    '''
    return lambda x: lambda y: f(x, y)


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    return lambda n: range(m, 1 + n)


# eq (==) :: Eq a => a -> a -> Bool
eq = curry(operator.eq)
'''True if a and b are comparable and a equals b.'''


# iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
def iterateUntil(p):
    '''A list of the results of repeated
       applications of f, until p matches.
    '''
    def go(f, x):
        vs = []
        v = x
        while True:
            if p(v):
                break
            vs.append(v)
            v = f(v)
        return vs

    return lambda f: lambda x: go(f, x)


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


# MAIN ---
if __name__ == '__main__':
    main()
