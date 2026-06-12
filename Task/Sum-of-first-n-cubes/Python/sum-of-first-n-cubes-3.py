'''Sum of first N cubes'''

from itertools import accumulate


# sumsOfFirstNCubes :: Int -> [Int]
def sumsOfFirstNCubes(n):
    '''Cumulative sums of the first N cubes.
    '''
    def go(a, x):
        return a + x ** 3

    return accumulate(range(0, n), go)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Cumulative sums of first 50 cubes'''
    print(
        table(5)([
            str(n) for n in sumsOfFirstNCubes(50)
        ])
    )


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


# table :: Int -> [String] -> String
def table(n):
    '''A list of strings formatted as
       right-justified rows of n columns.
    '''
    def go(xs):
        w = len(xs[-1])
        return '\n'.join(
            ' '.join(row) for row in chunksOf(n)([
                s.rjust(w, ' ') for s in xs
            ])
        )
    return go


# MAIN ---
if __name__ == '__main__':
    main()
