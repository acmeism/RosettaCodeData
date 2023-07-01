'''Prime sums of primes up to 1000'''


from itertools import accumulate, chain, takewhile


# primeSums :: [(Int, (Int, Int))]
def primeSums():
    '''Non finite stream of enumerated tuples,
       in which the first value is a prime,
       and the second the sum of that prime and all
       preceding primes.
    '''
    return (
        x for x in enumerate(
            accumulate(
                chain([(0, 0)], primes()),
                lambda a, p: (p, p + a[1])
            )
        ) if isPrime(x[1][1])
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Prime sums of primes below 1000'''
    for x in takewhile(
            lambda t: 1000 > t[1][0],
            primeSums()
    ):
        print(f'{x[0]} -> {x[1][1]}')


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


# primes :: [Int]
def primes():
    ''' Non finite sequence of prime numbers.
    '''
    n = 2
    dct = {}
    while True:
        if n in dct:
            for p in dct[n]:
                dct.setdefault(n + p, []).append(p)
            del dct[n]
        else:
            yield n
            dct[n * n] = [n]
        n = 1 + n


# MAIN ---
if __name__ == '__main__':
    main()
