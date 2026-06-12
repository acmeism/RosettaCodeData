'''Square and cube both have prime decimal digit sums'''

# p :: Int -> Bool
def p(n):
    '''True if the square and the cube of N both have
       decimal digit sums which are prime.
    '''
    return primeDigitSum(n ** 2) and primeDigitSum(n ** 3)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Matches in the range [1..99]'''
    print([
        x for x in range(2, 100)
        if p(x)
    ])


# ----------------------- GENERIC ------------------------

# primeDigitSum :: Int -> Bool
def primeDigitSum(n):
    '''True if the sum of the decimal digits of n is prime.
    '''
    return isPrime(digitSum(10)(n))


# digitSum :: Int -> Int
def digitSum(base):
    '''The sum of the digits of n in a given base.
    '''
    def go(n):
        q, r = divmod(n, base)
        return go(q) + r if n else 0
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

    def q(x):
        return 0 == n % x or 0 == n % (2 + x)

    return not any(map(q, range(5, 1 + int(n ** 0.5), 6)))


# MAIN ---
if __name__ == '__main__':
    main()
