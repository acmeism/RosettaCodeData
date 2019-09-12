'''Pascal's triangle'''

from itertools import (accumulate, chain, islice)
from operator import (add)


# nextPascal :: [Int] -> [Int]
def nextPascal(xs):
    '''A row of Pascal's triangle
       derived from a preceding row.'''
    return zipWith(add)([0] + xs)(xs + [0])


# pascalTriangle :: Generator [[Int]]
def pascalTriangle():
    '''A non-finite stream of
       Pascal's triangle rows.'''
    return iterate(nextPascal)([1])


# finitePascalRows :: Int -> [[Int]]
def finitePascalRows(n):
    '''The first n rows of Pascal's triangle.'''
    def go(a, _):
        return nextPascal(a)
    return scanl(go)([1])(
        range(1, n)
    )


# TESTS ---------------------------------------------------
# main :: IO ()
def main():
    '''Test of two different approaches:
        - taking from a non-finite stream of rows,
        - or constructing a finite list of rows.'''
    print(unlines(map(
        showPascal,
        [
            take(7)(
                pascalTriangle()        # Non finite,
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


# GENERIC -------------------------------------------------


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
    '''An infinite list of repeated applications of f to x.'''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return lambda x: go(x)


# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but returns a succession of
       intermediate values, building from the left.'''
    return lambda a: lambda xs: (
        accumulate(chain([a], xs), f)
    )


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else list(islice(xs, n))
    )


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
def zipWith(f):
    '''A list constructed by zipping with a
       custom function, rather than with the
       default tuple constructor.'''
    return lambda xs: lambda ys: (
        list(map(f, xs, ys))
    )


# MAIN ---
if __name__ == '__main__':
    main()
