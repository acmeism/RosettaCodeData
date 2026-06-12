'''Summatiom of primes'''

from functools import reduce


# sumOfPrimesBelow :: Int -> Int
def sumOfPrimesBelow(n):
    '''Sum of all primes between 2 and n'''
    def go(a, x):
        return a + x if isPrime(x) else a
    return reduce(go, range(2, n), 0)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Sum of primes below 2 million'''
    print(
        sumOfPrimesBelow(2_000_000)
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
