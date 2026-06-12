'''Prime sums of two consecutive integers'''

from itertools import chain, count, islice


# primeSumsOfTwoConsecutiveIntegers :: [Int]
def primeSumsOfTwoConsecutiveIntegers():
    '''Infinite series of prime sums of
       two consecutive integers.
    '''
    def go(a, b):
        n = a + b
        return [(n, (a, b))] if isPrime(n) else []

    return chain.from_iterable(
        map(go, count(1), count(2))
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First 20 prime sums of two consecutive integers.'''
    print(
        '\n'.join([
          f'{n} = {a} + {b}'  for n, (a, b) in islice(
                primeSumsOfTwoConsecutiveIntegers(),
                20
            )
        ])
    )


# ----------------------- GENERIC ------------------------

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

    def p(x):
        return 0 == n % x or 0 == n % (2 + x)

    return not any(map(p, range(5, 1 + int(n ** 0.5), 6)))


# MAIN ---
if __name__ == '__main__':
    main()
