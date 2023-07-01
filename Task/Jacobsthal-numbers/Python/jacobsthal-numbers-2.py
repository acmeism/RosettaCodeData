'''Jacobsthal numbers'''

from itertools import islice
from operator import mul


# jacobsthal :: [Integer]
def jacobsthal():
    '''Infinite sequence of terms of OEIS A001045
    '''
    return jacobsthalish(0, 1)


# jacobsthalish :: (Int, Int) -> [Int]
def jacobsthalish(*xy):
    '''Infinite sequence of jacobsthal-type series
       beginning with a, b
    '''
    def go(ab):
        a, b = ab
        return a, (b, 2 * a + b)

    return unfoldr(go)(xy)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First 15 terms each n-step Fibonacci(n) series
       where n is drawn from [2..8]
    '''
    print('\n\n'.join([
        fShow(*x) for x in [
            (
                'terms of the Jacobsthal sequence',
                30, jacobsthal()),
            (
                'Jacobsthal-Lucas numbers',
                30, jacobsthalish(2, 1)
            ),
            (
                'Jacobsthal oblong numbers',
                20, map(
                    mul, jacobsthal(),
                    drop(1)(jacobsthal())
                )
            ),
            (
                'primes in the Jacobsthal sequence',
                10, filter(isPrime, jacobsthal())
            )
        ]
    ]))


# fShow :: (String, Int, [Integer]) -> String
def fShow(k, n, xs):
    '''N tabulated terms of XS, prefixed by the label K
    '''
    return f'{n} {k}:\n' + spacedTable(
        list(chunksOf(5)(
            [str(t) for t in take(n)(xs)]
        ))
    )


# ----------------------- GENERIC ------------------------

# drop :: Int -> [a] -> [a]
# drop :: Int -> String -> String
def drop(n):
    '''The sublist of xs beginning at
       (zero-based) index n.
    '''
    def go(xs):
        if isinstance(xs, (list, tuple, str)):
            return xs[n:]
        else:
            take(n)(xs)
            return xs
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


# unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
def unfoldr(f):
    '''Generic anamorphism.
       A lazy (generator) list unfolded from a seed value by
       repeated application of f until no residue remains.
       Dual to fold/reduce.
       f returns either None, or just (value, residue).
       For a strict output value, wrap in list().
    '''
    def go(x):
        valueResidue = f(x)
        while None is not valueResidue:
            yield valueResidue[0]
            valueResidue = f(valueResidue[1])
    return go


# ---------------------- FORMATTING ----------------------

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


# spacedTable :: [[String]] -> String
def spacedTable(rows):
    '''Tabulated stringification of rows'''
    columnWidths = [
        max([len(x) for x in col])
        for col in zip(*rows)
    ]
    return '\n'.join([
        ' '.join(
            map(
                lambda x, w: x.rjust(w, ' '),
                row, columnWidths
            )
        )
        for row in rows
    ])


# MAIN ---
if __name__ == '__main__':
    main()
