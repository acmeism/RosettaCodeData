'''Palindromic primes'''

from itertools import takewhile


# palindromicPrimes :: Generator [Int]
def palindromicPrimes():
    '''An infinite stream of palindromic primes'''
    def p(n):
        s = str(n)
        return s == s[::-1]
    return (n for n in primes() if p(n))


# ------------------------- TEST -------------------------
def main():
    '''Palindromic primes below 1000'''
    print('\n'.join(
        str(x) for x in takewhile(
            lambda n: 1000 > n,
            palindromicPrimes()
        )
    ))


# ----------------------- GENERIC ------------------------

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
