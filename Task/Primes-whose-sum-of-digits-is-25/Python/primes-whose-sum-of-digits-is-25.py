'''Primes with a decimal digit sum of 25'''

from itertools import takewhile


# primesWithGivenDigitSum :: Int -> Int -> [Int]
def primesWithGivenDigitSum(below, n):
    '''Primes below a given value with
       decimal digits sums equal to n.
    '''
    return list(
        takewhile(
            lambda x: below > x,
            (
                x for x in primes()
                if n == sum(int(c) for c in str(x))
            )
        )
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test'''
    matches = primesWithGivenDigitSum(5000, 25)
    print(
        str(len(matches)) + (
            ' primes below 5000 with a decimal digit sum of 25:\n'
        )
    )
    print(
        '\n'.join([
            ' '.join([str(x).rjust(4, ' ') for x in xs])
            for xs in chunksOf(4)(matches)
        ])
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


# primes :: [Int]
def primes():
    ''' Non-finite sequence of prime numbers.
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
