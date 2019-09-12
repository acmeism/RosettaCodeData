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
