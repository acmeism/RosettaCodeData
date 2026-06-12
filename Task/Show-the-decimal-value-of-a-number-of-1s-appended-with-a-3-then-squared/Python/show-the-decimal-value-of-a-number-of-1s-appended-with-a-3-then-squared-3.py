'''Sequence of 1s appended with a 3, then squared'''

from itertools import islice


# seriesOfOnesEndingWithThree :: [Int]
def seriesOfOnesEndingWithThree():
    '''An ordered and non-finite stream of integers
       whose decimal digits end in 3, preceded only by a
       series of (zero or more) ones.
       (3, 13, 113, 1113 ...)
    '''
    def go(n):
        return lambda x: n + 10 * x

    return fmapGen(go(3))(
        iterate(go(1))(0)
    )


# showSquare :: (Int, Int, Int) -> String
def showSquare(ew, vw, n):
    '''A string representation of the square of n,
       both as an expression and as a value, with a
       right-justfied expression column of width ew,
       and a right-justified value column of width vw.
    '''
    return f'{str(n).rjust(ew)}^2 = {str(n ** 2).rjust(vw)}'


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Listing of the first 7 values of the series.'''

    xs = take(7)(
        seriesOfOnesEndingWithThree()
    )

    final = xs[-1]
    w = len(str(final))
    w1 = len(str(final ** 2))
    print('\n'.join([
        showSquare(w, w1, x) for x in xs
    ]))


# ----------------------- GENERIC ------------------------

# fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
def fmapGen(f):
    '''A function f mapped over a
       non finite stream of values.
    '''
    def go(g):
        while True:
            v = next(g, None)
            if None is not v:
                yield f(v)
            else:
                return
    return go


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated
       applications of f to x.
    '''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return go


# take :: Int -> [a] -> [a]
def take(n):
    '''The first n values of xs.
    '''
    return lambda xs: list(islice(xs, n))


# MAIN ---
if __name__ == '__main__':
    main()
