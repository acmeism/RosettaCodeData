'''Odd abundant numbers'''

from math import sqrt
from itertools import chain, count, islice


# abundantTuple :: Int -> [(Int, Int)]
def abundantTuple(n):
    '''A list containing the tuple of N and its divisor
       sum, if n is abundant, or an empty list.
    '''
    x = divisorSum(n)
    return [(n, x)] if n < x else []


#  divisorSum :: Int -> Int
def divisorSum(n):
    '''Sum of the divisors of n.'''
    floatRoot = sqrt(n)
    intRoot = int(floatRoot)
    blnSquare = intRoot == floatRoot
    lows = [x for x in range(1, 1 + intRoot) if 0 == n % x]
    return sum(lows + [
        n // x for x in (
            lows[1:-1] if blnSquare else lows[1:]
        )
    ])


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Subsets of abundant odd numbers.'''

    # First 25.
    print('First 25 abundant odd numbers with their divisor sums:')
    for x in take(25)(
            concatMap(abundantTuple)(
                enumFromThen(1)(3)
            )
    ):
        print(x)

    # The 1000th.
    print('\n1000th odd abundant number with its divisor sum:')
    print(
        take(1000)(
            concatMap(abundantTuple)(
                enumFromThen(1)(3)
            )
        )[-1]
    )

    # First over 10^9.
    print('\nFirst odd abundant number over 10^9, with its divisor sum:')
    billion = (10 ** 9)
    print(
        take(1)(
            concatMap(abundantTuple)(
                enumFromThen(1 + billion)(3 + billion)
            )
        )[0]
    )


# GENERAL FUNCTIONS ---------------------------------------

# enumFromThen :: Int -> Int -> [Int]
def enumFromThen(m):
    '''A non-finite stream of integers
       starting at m, and continuing
       at the interval between m and n.
    '''
    return lambda n: count(m, n - m)


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function f
       has been mapped.
       The list monad can be derived by using an (a -> [b])
       function which wraps its output in a list (using an
       empty list to represent computational failure).
    '''
    return lambda xs: (
        chain.from_iterable(map(f, xs))
    )


# take :: Int -> [a] -> [a]
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        list(islice(xs, n))
    )


if __name__ == '__main__':
    main()
