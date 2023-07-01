'''Department numbers'''

from itertools import (chain)
from operator import (ne)


# options :: Int -> Int -> Int -> [(Int, Int, Int)]
def options(lo, hi, total):
    '''Eligible integer triples.'''
    ds = enumFromTo(lo)(hi)
    return bind(filter(even, ds))(
        lambda x: bind(filter(curry(ne)(x), ds))(
            lambda y: bind([total - (x + y)])(
                lambda z: [(x, y, z)] if (
                    z != y and lo <= z <= hi
                ) else []
            )
        )
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''

    xs = options(1, 7, 12)
    print(('Police', 'Sanitation', 'Fire'))
    for tpl in xs:
        print(tpl)
    print('\nNo. of options: ' + str(len(xs)))


# GENERIC ABSTRACTIONS ------------------------------------

# bind (>>=) :: [a] -> (a -> [b]) -> [b]
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


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    return lambda a: lambda b: f(a, b)


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# even :: Int -> Bool
def even(x):
    '''True if x is an integer
       multiple of two.'''
    return 0 == x % 2


if __name__ == '__main__':
    main()
