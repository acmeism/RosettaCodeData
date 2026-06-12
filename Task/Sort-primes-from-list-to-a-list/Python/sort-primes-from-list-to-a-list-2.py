'''Prime elements in rising order'''


# primeElementsSorted :: [Int] -> [Int]
def primeElementsSorted(xs):
    '''The prime elements of xs in rising order'''
    return sorted(x for x in xs if isPrime(x))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Filtered elements of given list in rising order'''

    print(
        primeElementsSorted([
            2, 43, 81, 122, 63, 13, 7, 95, 103
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
