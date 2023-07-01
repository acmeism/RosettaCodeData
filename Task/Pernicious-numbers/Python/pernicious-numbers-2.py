'''Pernicious numbers'''

from itertools import count, islice


# isPernicious :: Int -> Bool
def isPernicious(n):
    '''True if the population count of n is
       a prime number.
    '''
    return isPrime(popCount(n))


# oeisA052294 :: [Int]
def oeisA052294():
    '''A non-finite stream of pernicious numbers.
       (Numbers with a prime population count)
    '''
    return (x for x in count(1) if isPernicious(x))


# popCount :: Int -> Int
def popCount(n):
    '''The count of non-zero digits in the binary
       representation of the positive integer n.
    '''
    def go(x):
        return divmod(x, 2) if 0 < x else None
    return sum(unfoldl(go)(n))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First 25, and any in the range
       [888,888,877..888,888,888]
    '''

    print(
        take(25)(
            oeisA052294()
        )
    )
    print([
        x for x in enumFromTo(888888877)(888888888)
        if isPernicious(x)
    ])


# ----------------------- GENERIC ------------------------

# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    def go(n):
        return range(m, 1 + n)
    return go


# isPrime :: Int -> Bool
def isPrime(n):
    '''True if n is prime.'''
    if n in (2, 3):
        return True
    if 2 > n or 0 == n % 2:
        return False
    if 9 > n:
        return True
    if 0 == n % 3:
        return False

    return not any(map(
        lambda x: 0 == n % x or 0 == n % (2 + x),
        range(5, 1 + int(n ** 0.5), 6)
    ))


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
    )


# unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
def unfoldl(f):
    '''A lazy (generator) list unfolded from a seed value
       by repeated application of f until no residue remains.
       Dual to fold/reduce.
       f returns either None or just (residue, value).
       For a strict output list, wrap the result with list()
    '''
    def go(v):
        residueValue = f(v)
        while residueValue:
            yield residueValue[1]
            residueValue = f(residueValue[0])
    return go


# MAIN ---
if __name__ == '__main__':
    main()
