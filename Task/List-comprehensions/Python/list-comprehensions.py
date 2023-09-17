import itertools
n = 20

# List comprehension:
[(x,y,z) for x in xrange(1,n+1) for y in xrange(x,n+1) for z in xrange(y,n+1) if x**2 + y**2 == z**2]

# A Python generator expression (note the outer round brackets),
# returns an iterator over the same result rather than an explicit list:
((x,y,z) for x in xrange(1,n+1) for y in xrange(x,n+1) for z in xrange(y,n+1) if x**2 + y**2 == z**2)

# A slower but more readable version:
[(x, y, z) for (x, y, z) in itertools.product(xrange(1,n+1),repeat=3) if x**2 + y**2 == z**2 and x <= y <= z]

# Or as an iterator:
((x, y, z) for (x, y, z) in itertools.product(xrange(1,n+1),repeat=3) if x**2 + y**2 == z**2 and x <= y <= z)

# Alternatively we shorten the initial list comprehension but this time without compromising on speed.
# First we introduce a generator which generates all triplets:
def triplets(n):
    for x in xrange(1, n + 1):
        for y in xrange(x, n + 1):
            for z in xrange(y, n + 1):
                yield x, y, z

# Apply this to our list comprehension gives:
[(x, y, z) for (x, y, z) in triplets(n) if x**2 + y**2 == z**2]

# Or as an iterator:
((x, y, z) for (x, y, z) in triplets(n) if x**2 + y**2 == z**2)

# More generally, the list comprehension syntax can be understood as a concise syntactic sugaring
# of a use of the list monad, in which non-matches are returned as empty lists, matches are wrapped
# as single-item lists, and concatenation flattens the output, eliminating the empty lists.

# The monadic 'bind' operator for lists is concatMap, traditionally used with its first two arguments flipped.
# The following three formulations of a '''pts''' (pythagorean triangles) function are equivalent:

from functools import (reduce)
from operator import (add)

# pts :: Int -> [(Int, Int, Int)]
def pts(n):
    m = 1 + n
    return [(x, y, z) for x in xrange(1, m)
            for y in xrange(x, m)
            for z in xrange(y, m) if x**2 + y**2 == z**2]


# pts2 :: Int -> [(Int, Int, Int)]
def pts2(n):
    m = 1 + n
    return bindList(
        xrange(1, m)
    )(lambda x: bindList(
        xrange(x, m)
    )(lambda y: bindList(
        xrange(y, m)
    )(lambda z: [(x, y, z)] if x**2 + y**2 == z**2 else [])))


# pts3 :: Int -> [(Int, Int, Int)]
def pts3(n):
    m = 1 + n
    return concatMap(
        lambda x: concatMap(
            lambda y: concatMap(
                lambda z: [(x, y, z)] if x**2 + y**2 == z**2 else []
            )(xrange(y, m))
        )(xrange(x, m))
    )(xrange(1, m))


# GENERIC ---------------------------------------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    return lambda xs: (
        reduce(add, map(f, xs), [])
    )


# (flip concatMap)
# bindList :: [a] -> (a -> [b])  -> [b]
def bindList(xs):
    return lambda f: (
        reduce(add, map(f, xs), [])
    )


def main():
    for f in [pts, pts2, pts3]:
        print (f(20))


main()
