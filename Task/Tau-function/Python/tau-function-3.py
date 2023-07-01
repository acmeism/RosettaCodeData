'''The number of divisors of n'''

from itertools import count, islice
from math import floor, sqrt


# oeisA000005 :: [Int]
def oeisA000005():
    '''tau(n) (also called d(n) or sigma_0(n)),
       the number of divisors of n.
    '''
    return map(tau, count(1))


# tau :: Int -> Int
def tau(n):
    '''The number of divisors of n.
    '''
    return len(divisors(n))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''The first 100 terms of OEIS A000005.
       (Shown in rows of 10)
    '''
    terms = take(100)(
        oeisA000005()
    )
    columnWidth = 1 + len(str(max(terms)))

    print(
        '\n'.join(
            ''.join(
                str(term).rjust(columnWidth)
                for term in row
            )
            for row in chunksOf(10)(terms)
        )
    )


# ----------------------- GENERIC ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    def go(xs):
        return [
            xs[i:n + i] for i in range(0, len(xs), n)
        ] if 0 < n else None
    return go


# divisors :: Int -> [Int]
def divisors(n):
    '''List of all divisors of n including n itself.
    '''
    root = floor(sqrt(n))
    lows = [x for x in range(1, 1 + root) if 0 == n % x]
    return lows + [n // x for x in reversed(lows)][
        (1 if n == (root * root) else 0):
    ]


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    def go(xs):
        return (
            xs[0:n]
            if isinstance(xs, (list, tuple))
            else list(islice(xs, n))
        )
    return go


# MAIN ---
if __name__ == '__main__':
    main()
