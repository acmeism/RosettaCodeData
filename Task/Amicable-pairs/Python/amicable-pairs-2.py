'''Amicable pairs'''

from itertools import chain
from math import sqrt


# amicablePairsUpTo :: Int -> [(Int, Int)]
def amicablePairsUpTo(n):
    '''List of all amicable pairs
       of integers below n.
    '''
    sigma = compose(sum)(properDivisors)

    def amicable(x):
        y = sigma(x)
        return [(x, y)] if (x < y and x == sigma(y)) else []

    return concatMap(amicable)(
        enumFromTo(1)(n)
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Amicable pairs of integers up to 20000'''

    for x in amicablePairsUpTo(20000):
        print(x)


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list or string over which a function f
       has been mapped.
       The list monad can be derived by using an (a -> [b])
       function which wraps its output in a list (using an
       empty list to represent computational failure).
    '''
    return lambda xs: (''.join if isinstance(xs, str) else list)(
        chain.from_iterable(map(f, xs))
    )


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    def go(n):
        return list(range(m, 1 + n))
    return lambda n: go(n)


# properDivisors :: Int -> [Int]
def properDivisors(n):
    '''Positive divisors of n, excluding n itself'''
    root_ = sqrt(n)
    intRoot = int(root_)
    blnSqr = root_ == intRoot
    lows = [x for x in range(1, 1 + intRoot) if 0 == n % x]
    return lows + [
        n // x for x in reversed(
            lows[1:-1] if blnSqr else lows[1:]
        )
    ]


# MAIN ---
if __name__ == '__main__':
    main()
