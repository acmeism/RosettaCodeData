'''Munchausen numbers'''

from functools import (reduce)


# isMunchausen :: Int -> Bool
def isMunchausen(n):
    '''True if n equals the sum of
       each of its digits raised to
       the power of itself.'''
    def powerOfSelf(d):
        i = digitToInt(d)
        return i**i
    return n == reduce(
        lambda n, c: n + powerOfSelf(c),
        str(n), 0
    )


# main :: IO ()
def main():
    '''Test'''
    print(list(filter(
        isMunchausen,
        enumFromTo(1)(5000)
    )))


# GENERIC -------------------------------------------------

# digitToInt :: Char -> Int
def digitToInt(c):
    '''The integer value of any digit character
       drawn from the 0-9, A-F or a-f ranges.'''
    oc = ord(c)
    if 48 > oc or 102 < oc:
        return None
    else:
        dec = oc - 48   # ord('0')
        hexu = oc - 65  # ord('A')
        hexl = oc - 97  # ord('a')
    return dec if 9 >= dec else (
        10 + hexu if 0 <= hexu <= 5 else (
            10 + hexl if 0 <= hexl <= 5 else None
        )
    )


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


if __name__ == '__main__':
    main()
