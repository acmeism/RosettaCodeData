'''Largest number divisible by its hex digits'''

from functools import (reduce)
from math import (gcd)


# main :: IO ()
def main():
    '''First integer evenly divisible by each of its
       hex digits, none of which appear more than once.
    '''

    # Least common multiple of digits [1..15]
    # ( -> 360360 )
    lcmDigits = foldl1(lcm)(
        enumFromTo(1)(15)
    )
    allDigits = 0xfedcba987654321

    # ( -> 1147797409030632360 )
    upperLimit = allDigits - (allDigits % lcmDigits)

    # Possible numbers
    xs = enumFromThenToNext(upperLimit)(
        upperLimit - lcmDigits
    )(1)

    print(
        hex(
            until(lambda x: 15 == len(set(showHex(x))))(
                lambda _: next(xs)
            )(next(xs))
        )
    )   # --> 0xfedcb59726a1348


# ------------------ GENERIC FUNCTIONS -------------------

# enumFromThenToNext :: Int -> Int -> Int -> Gen [Int]
def enumFromThenToNext(m):
    '''Non-finite series of integer values enumerated
       from m to n with a step size defined by nxt-m.
    '''
    def go(m, nxt):
        d = nxt - m
        v = m
        while True:
            yield v
            v = d + v
    return lambda nxt: lambda n: go(m, nxt)


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: range(m, 1 + n)


# foldl1 :: (a -> a -> a) -> [a] -> a
def foldl1(f):
    '''Left to right reduction of the
       non-empty list xs, using the binary
       operator f, with the head of xs
       as the initial acccumulator value.
    '''
    return lambda xs: reduce(
        lambda a, x: f(a)(x), xs[1:], xs[0]
    ) if xs else None


# lcm :: Int -> Int -> Int
def lcm(x):
    '''The smallest positive integer divisible
       without remainder by both x and y.
    '''
    return lambda y: (
        0 if (0 == x or 0 == y) else abs(
            y * (x // gcd(x, y))
        )
    )


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


# showHex :: Int -> String
def showHex(n):
    '''Hexadecimal string representation
       of an integer value.
    '''
    return hex(n)[2:]


# MAIN --
if __name__ == '__main__':
    main()
