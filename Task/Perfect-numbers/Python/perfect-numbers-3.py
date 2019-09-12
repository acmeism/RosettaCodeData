'''Perfect numbers'''

from math import sqrt


# perfect :: Int - > Bool
def perfect(n):
    '''Is n the sum of its proper divisors other than 1 ?'''

    root = sqrt(n)
    lows = [x for x in enumFromTo(2)(int(root)) if 0 == (n % x)]
    return 1 < n and (
        n == 1 + sum(lows + [n / x for x in lows if root != x])
    )


# main :: IO ()
def main():
    '''Test'''

    print([
        x for x in enumFromTo(1)(10000) if perfect(x)
    ])


# GENERIC -------------------------------------------------

# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


if __name__ == '__main__':
    main()
