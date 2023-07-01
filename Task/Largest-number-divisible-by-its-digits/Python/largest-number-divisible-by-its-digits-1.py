'''Largest number divisible by its digits'''

from itertools import (chain, permutations)
from functools import (reduce)
from math import (gcd)


# main :: IO ()
def main():
    '''Tests'''

    # (Division by zero is not an option, so 0 and 5 are omitted)
    digits = [1, 2, 3, 4, 6, 7, 8, 9]

    # Least common multiple of the digits above
    lcmDigits = reduce(lcm, digits)

    # Any 7 items drawn from the digits above,
    # including any two of [1, 4, 7]
    sevenDigits = ((delete)(digits)(x) for x in [1, 4, 7])

    print(
        max(
            (
                intFromDigits(x) for x
                in concatMap(permutations)(sevenDigits)
            ),
            key=lambda n: n if 0 == n % lcmDigits else 0
        )
    )


# intFromDigits :: [Int] -> Int
def intFromDigits(xs):
    '''An integer derived from an
       ordered list of digits.
    '''
    return reduce(lambda a, x: a * 10 + x, xs, 0)


# ----------------------- GENERIC ------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been
       mapped. The list monad can be derived by using a
       function f which wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


# delete :: Eq a => [a] -> a -> [a]
def delete(xs):
    '''xs with the first instance of
       x removed.
    '''
    def go(x):
        ys = xs.copy()
        ys.remove(x)
        return ys
    return go


# lcm :: Int -> Int -> Int
def lcm(x, y):
    '''The smallest positive integer divisible
       without remainder by both x and y.
    '''
    return 0 if (0 == x or 0 == y) else abs(
        y * (x // gcd(x, y))
    )


# MAIN ---
if __name__ == '__main__':
    main()
