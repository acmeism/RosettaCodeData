'''Cousin primes'''

from itertools import chain, takewhile


# cousinPrimes :: [Int]
def cousinPrimes():
    '''Non finite list of pairs of primes which differ by 4.
    '''
    def go(x):
        n = 4 + x
        return [(x, n)] if isPrime(n) else []

    return chain.from_iterable(
        map(go, primes())
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Cousin pairs where each value is below 1000'''

    pairs = list(
        takewhile(
            lambda ab: 1000 > ab[1],
            cousinPrimes()
        )
    )

    print(f'{len(pairs)} cousin pairs below 1000:\n')
    print(
        spacedTable(list(
            chunksOf(4)([
                repr(x) for x in pairs
            ])
        ))
    )


# ----------------------- GENERIC ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    def go(xs):
        return (
            xs[i:n + i] for i in range(0, len(xs), n)
        ) if 0 < n else None
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


# listTranspose :: [[a]] -> [[a]]
def listTranspose(xss):
    '''Transposition of a list of lists
    '''
    def go(xss):
        if xss:
            h, *t = xss
            return (
                [[h[0]] + [xs[0] for xs in t if xs]] + (
                    go([h[1:]] + [xs[1:] for xs in t])
                )
            ) if h and isinstance(h, list) else go(t)
        else:
            return []
    return go(xss)


# spacedTable :: [[String]] -> String
def spacedTable(rows):
    '''Tabulation with right-aligned cells'''
    columnWidths = [
        len(str(row[-1])) for row in listTranspose(rows)
    ]
    return '\n'.join([
        ' '.join(
            map(
                lambda w, s: s.rjust(w, ' '),
                columnWidths, row
            )
        ) for row in rows
    ])


# MAIN ---
if __name__ == '__main__':
    main()
