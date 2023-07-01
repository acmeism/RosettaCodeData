'''A131382'''

from itertools import count, islice


# a131382 :: [Int]
def a131382():
    '''An infinite series of the terms of A131382'''
    return (
        elemIndex(x)(
            productDigitSums(x)
        ) for x in count(1)
    )


# productDigitSums :: Int -> [Int]
def productDigitSums(n):
    '''The sum of the decimal digits of n'''
    return (digitSum(n * x) for x in count(0))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First 40 terms of A131382'''

    print(
        table(10)([
            str(x) for x in islice(
                a131382(),
                40
            )
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


# digitSum :: Int -> Int
def digitSum(n):
    '''The sum of the digital digits of n.
    '''
    return sum(int(x) for x in list(str(n)))


# elemIndex :: a -> [a] -> (None | Int)
def elemIndex(x):
    '''Just the first index of x in xs,
       or None if no elements match.
    '''
    def go(xs):
        try:
            return next(
                i for i, v in enumerate(xs) if x == v
            )
        except StopIteration:
            return None
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
