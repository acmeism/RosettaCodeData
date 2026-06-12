'''Primes with monotonic (rising or equal) digits'''

from operator import le
from itertools import takewhile


# monotonicDigits :: Int -> Int -> Bool
def monotonicDigits(base):
    '''True if the decimal digits of n
       are monotonic under (<=)
    '''
    def go(n):
        return monotonic(le)(
            showIntAtBase(base)(digitFromInt)(n)('')
        )
    return go


# monotonic :: (a -> a -> Bool) -> [a] -> Bool
def monotonic(op):
    '''True if the op returns True for each
       successive pair of values in xs.
    '''
    def go(xs):
        return all(map(op, xs, xs[1:]))
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Primes below 1000 in which any decimal digit is
       lower than or equal to any digit to its right.
    '''
    xs = [
        str(n) for n in takewhile(
            lambda n: 1000 > n,
            filter(monotonicDigits(10), primes())
        )
    ]
    w = len(xs[-1])
    print(f'{len(xs)} matches for base 10:\n')
    print('\n'.join(
        ' '.join(row) for row in chunksOf(10)([
            x.rjust(w, ' ') for x in xs
        ])
    ))


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


# digitFromInt :: Int -> Char
def digitFromInt(n):
    '''A character representing a small
       integer value.
    '''
    return '0123456789abcdefghijklmnopqrstuvwxyz'[n] if (
        0 <= n < 36
    ) else '?'


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


# showIntAtBase :: Int -> (Int -> Char) -> Int ->
# String -> String
def showIntAtBase(base):
    '''String representation of an integer in a given base,
       using a supplied function for the string
       representation of digits.
    '''
    def wrap(toChr, n, rs):
        def go(nd, r):
            n, d = nd
            r_ = toChr(d) + r
            return go(divmod(n, base), r_) if 0 != n else r_
        return 'unsupported base' if 1 >= base else (
            'negative number' if 0 > n else (
                go(divmod(n, base), rs))
        )
    return lambda toChr: lambda n: lambda rs: (
        wrap(toChr, n, rs)
    )


# MAIN ---
if __name__ == '__main__':
    main()
