'''Largest proper divisor of'''

from math import isqrt


# maxProperDivisors :: Int -> Int
def maxProperDivisors(n):
    '''The largest proper divisor of n.
    '''
    secondDivisor = find(
        lambda x: 0 == (n % x)
    )(
        range(2, 1 + isqrt(n))
    )
    return 1 if None is secondDivisor else (
        n // secondDivisor
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test for values of n in [1..100]'''

    xs = [
        maxProperDivisors(n) for n
        in range(1, 1 + 100)
    ]

    colWidth = 1 + len(str(max(xs)))

    print(
        '\n'.join([
            ''.join(row) for row in
            chunksOf(10)([
                str(x).rjust(colWidth, " ") for x in xs
            ])
        ])
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


# find :: (a -> Bool) -> [a] -> (a | None)
def find(p):
    '''Just the first element in the list that matches p,
       or None if no elements match.
    '''
    def go(xs):
        try:
            return next(x for x in xs if p(x))
        except StopIteration:
            return None
    return go


# MAIN ---
if __name__ == '__main__':
    main()
