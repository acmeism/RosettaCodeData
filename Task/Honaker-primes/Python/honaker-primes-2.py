'''Honaker primes'''

from itertools import count, islice
from functools import reduce

# honakers :: [Int]
def honakers():
    '''Infinite stream of Honaker primes,
       tupled with their 1-based indices
       in the series of prime integers.
    '''
    def p(ip):
        return digitSum(ip[0]) == digitSum(ip[1])

    return filter(
        p, enumerate(primes(), 1)
    )


# digitSum :: Int -> Int
def digitSum(n):
    '''Sum of the decimal digits of the given integer.
    '''
    return reduce(
        lambda a, c: a + int(c),
        str(n),
        0
    )

# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First 50 Honaker primes, and ten thousandth.'''

    print ("First 50 (prime index, Honaker) pairs:")
    print(
        table(5)([
            str(n) for n in
            islice(honakers(), 50)
        ])
    )

    print("\n10Kth:\n")
    print(
        next(islice(honakers(), 10000-1, None))
    )


# ----------------------- GENERIC ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divisible, the final list will be shorter than n.
    '''
    def go(xs):
        return (
            xs[i:n + i] for i in range(0, len(xs), n)
        ) if 0 < n else None
    return go


# primes :: [Int]
def primes():
    '''An infinite stream of primes.
    '''
    seen = {}
    p = None
    yield 2
    for q in count(3, 2):
        p = seen.pop(q, None)
        if p is None:
            seen[q ** 2] = q
            yield q
        else:
            seen[
                until(
                    lambda x: x not in seen,
                    lambda x: x + 2 * p,
                    q + 2 * p
                )
            ] = p


# table :: Int -> [String] -> String
def table(n):
    '''A list of strings formatted as
       right-justified rows of n columns.
    '''
    def go(xs):
        w = len(max(xs, key=len))
        return '\n'.join(
            ' '.join(row) for row in chunksOf(n)([
                s.rjust(w, ' ') for s in xs
            ])
        )
    return go


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p, f, x):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    v = x
    while not p(v):
        v = f(v)
    return v


# MAIN ---
if __name__ == '__main__':
    main()
