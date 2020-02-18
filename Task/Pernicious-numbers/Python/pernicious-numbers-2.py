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
        return Just(divmod(x, 2)) if 0 < x else Nothing()
    return sum(unfoldl(go)(n))


# TEST ----------------------------------------------------
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
        x for x in enumFromTo(888888877)(
            888888888
        ) if isPernicious(x)
    ])


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.
       Wrapper containing the result of a computation.
    '''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return {'type': 'Maybe', 'Nothing': True}


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    def go(n):
        return list(range(m, 1 + n))
    return lambda n: go(n)


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
    '''Dual to reduce or foldl.
       Where these reduce a list to a summary value, unfoldl
       builds a list from a seed value.
       Where f returns Just(a, b), a is appended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns Nothing, the completed list is returned.
    '''
    def go(v):
        x, r = v, v
        xs = []
        while True:
            mb = f(x)
            if mb.get('Nothing'):
                return xs
            else:
                x, r = mb.get('Just')
                xs.insert(0, r)
        return xs
    return lambda x: go(x)


# MAIN ---
if __name__ == '__main__':
    main()
