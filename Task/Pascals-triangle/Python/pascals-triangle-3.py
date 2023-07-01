'''Pascal's triangle'''

from itertools import (accumulate, chain, islice)
from operator import (add)


# nextPascal :: [Int] -> [Int]
def nextPascal(xs):
    '''A row of Pascal's triangle
       derived from a preceding row.'''
    return list(
        map(add, [0] + xs, xs + [0])
    )


# pascalTriangle :: Generator [[Int]]
def pascalTriangle():
    '''A non-finite stream of
       Pascal's triangle rows.'''
    return iterate(nextPascal)([1])


# finitePascalRows :: Int -> [[Int]]
def finitePascalRows(n):
    '''The first n rows of Pascal's triangle.'''
    return accumulate(
        chain(
            [[1]], range(1, n)
        ),
        lambda a, _: nextPascal(a)
    )


# ------------------------ TESTS -------------------------
# main :: IO ()
def main():
    '''Test of two different approaches:
        - taking from a non-finite stream of rows,
        - or constructing a finite list of rows.'''
    print('\n'.join(map(
        showPascal,
        [
            islice(
                pascalTriangle(),       # Non finite,
                7
            ),
            finitePascalRows(7)         # finite.
        ]
    )))


# showPascal :: [[Int]] -> String
def showPascal(xs):
    '''Stringification of a list of
       Pascal triangle rows.'''
    ys = list(xs)

    def align(w):
        return lambda ns: center(w)(
            ' '
        )('   '.join(map(str, ns)))

    w = len('   '.join((map(str, ys[-1]))))
    return '\n'.join(map(align(w), ys))


# ----------------------- GENERIC ------------------------

# center :: Int -> Char -> String -> String
def center(n):
    '''String s padded with c to approximate centre,
       fitting in but not truncated to width n.'''
    def go(c, s):
        qr = divmod(n - len(s), 2)
        q = qr[0]
        return (q * c) + s + ((q + qr[1]) * c)

    return lambda c: lambda s: go(c, s)


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


# MAIN ---
if __name__ == '__main__':
    main()
