'''Summatiom of primes'''

from itertools import count, takewhile


# sumOfPrimesBelow :: Int -> Int
def sumOfPrimesBelow(n):
    '''Sum of all primes between 2 and n'''
    return sum(takewhile(lambda x: n > x, primes()))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Sum of primes below 2 million'''
    print(
        sumOfPrimesBelow(2_000_000)
    )


# ----------------------- GENERIC ------------------------

# enumFromThen :: Int -> Int -> [Int]
def enumFromThen(m):
    '''A non-finite stream of integers
       starting at m, and continuing
       at the interval between m and n.
    '''
    return lambda n: count(m, n - m)


# primes :: [Int]
def primes():
    '''An infinite stream of primes.'''
    seen = {}
    yield 2
    p = None
    for q in enumFromThen(3)(5):
        p = seen.pop(q, None)
        if p is None:
            seen[q ** 2] = q
            yield q
        else:
            seen[
                until(
                    lambda x: x not in seen,
                    lambda x: x + 2 * p,
                    q + 2 * p
                )
            ] = p


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p, f, v):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    while not p(v):
        v = f(v)
    return v


# MAIN ---
if __name__ == '__main__':
    main()
