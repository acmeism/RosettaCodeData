'''Perfect squares using every digit in a given base.'''

from itertools import count, dropwhile, repeat
from math import ceil, sqrt
from time import time


# allDigitSquare :: Int -> Int -> Int
def allDigitSquare(base, above):
    '''The lowest perfect square which
       requires all digits in the given base.
    '''
    bools = list(repeat(True, base))
    return next(
        dropwhile(
            missingDigitsAtBase(base, bools),
            count(
                max(
                    above,
                    ceil(sqrt(int(
                        '10' + '0123456789abcdef'[2:base],
                        base
                    )))
                )
            )
        )
    )


# missingDigitsAtBase :: Int -> [Bool] -> Int -> Bool
def missingDigitsAtBase(base, bools):
    '''Fusion of representing the square of integer N at a
       given base with checking whether all digits of
       that base contribute to N^2.
       Clears the bool at a digit position to False when used.
       True if any positions remain uncleared (unused).
    '''
    def go(x):
        xs = bools.copy()
        while x:
            xs[x % base] = False
            x //= base
        return any(xs)
    return lambda n: go(n * n)


# digit :: Int -> Char
def digit(n):
    '''Digit character for given integer.'''
    return '0123456789abcdef'[n]


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Smallest perfect squares using all digits in bases 2-16'''

    start = time()

    print(main.__doc__ + ':\n\nBase      Root    Square')
    q = 0
    for b in enumFromTo(2)(16):
        q = allDigitSquare(b, q)
        print(
            str(b).rjust(2, ' ') + ' -> ' +
            showIntAtBase(b)(digit)(q)('').rjust(8, ' ') +
            ' -> ' +
            showIntAtBase(b)(digit)(q * q)('')
        )

    print(
        '\nc. ' + str(ceil(time() - start)) + ' seconds.'
    )


# ----------------------- GENERIC ------------------------

# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# showIntAtBase :: Int -> (Int -> String) -> Int ->
# String -> String
def showIntAtBase(base):
    '''String representation of an integer in a given base,
       using a supplied function for the string representation
       of digits.
    '''
    def wrap(toChr, n, rs):
        def go(nd, r):
            n, d = nd
            r_ = toChr(d) + r
            return go(divmod(n, base), r_) if 0 != n else r_
        return 'unsupported base' if 1 >= base else (
            'negative number' if 0 > n else (
                go(divmod(n, base), rs))
        )
    return lambda toChr: lambda n: lambda rs: (
        wrap(toChr, n, rs)
    )


# MAIN ---
if __name__ == '__main__':
    main()
