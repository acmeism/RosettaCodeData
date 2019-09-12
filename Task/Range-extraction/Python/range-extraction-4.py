'''Range extraction'''

from functools import reduce


# rangeFormat :: [Int] -> String
def rangeFormat(xs):
    '''Range-formatted display string for
       a list of integers.
    '''
    return ','.join([
        rangeString(x) for x
        in splitBy(lambda a, b: 1 < b - a)(xs)
    ])


# rangeString :: [Int] -> String
def rangeString(xs):
    '''Start and end of xs delimited by hyphens
       if there are more than two integers.
       Otherwise, comma-delimited xs.
    '''
    ys = [str(x) for x in xs]
    return '-'.join([ys[0], ys[-1]]) if 2 < len(ys) else (
        ','.join(ys)
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''

    xs = [
        0, 1, 2, 4, 6, 7, 8, 11, 12, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
        37, 38, 39
    ]
    print(
        __doc__ + ':\n[' + '\n'.join(map(
            lambda x: ' ' + repr(x)[1:-1],
            chunksOf(11)(xs)
        )) + " ]\n\n        -> '" + rangeFormat(xs) + "'\n"
    )


# GENERIC -------------------------------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n,
       subdividing the contents of xs.
       Where the length of xs is not evenly divible,
       the final list will be shorter than n.'''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
def splitBy(p):
    '''A list split wherever two consecutive
       items match the binary predicate p.
    '''
    # step :: ([[a]], [a], a) -> a -> ([[a]], [a], a)
    def step(acp, x):
        acc, active, prev = acp
        return (acc + [active], [x], x) if p(prev, x) else (
            (acc, active + [x], x)
        )

    # go :: [a] -> [[a]]
    def go(xs):
        if 2 > len(xs):
            return xs
        else:
            h = xs[0]
            ys = reduce(step, xs[1:], ([], [h], h))
            # The accumulated sublists, and the current group.
            return ys[0] + [ys[1]]

    return lambda xs: go(xs)


# MAIN ---
if __name__ == '__main__':
    main()
