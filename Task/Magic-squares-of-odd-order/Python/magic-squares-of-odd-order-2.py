'''Magic squares of odd order N'''

from itertools import cycle, islice, repeat
from functools import reduce


# magicSquare :: Int -> [[Int]]
def magicSquare(n):
    '''Magic square of odd order n.'''
    return applyN(2)(
        compose(transposed)(cycled)
    )(plainSquare(n)) if 1 == n % 2 else []


# plainSquare :: Int -> [[Int]]
def plainSquare(n):
    '''The sequence of integers from 1 to N^2,
       subdivided into N sub-lists of equal length,
       forming N rows, each of N integers.
    '''
    return chunksOf(n)(
        enumFromTo(1)(n ** 2)
    )


# cycled :: [[Int]] -> [[Int]]
def cycled(rows):
    '''A table in which the rows are
       rotated by descending deltas.
    '''
    n = len(rows)
    d = n // 2
    return list(map(
        lambda d, xs: take(n)(
            drop(n - d)(cycle(xs))
        ),
        enumFromThenTo(d)(d - 1)(-d),
        rows
    ))


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Magic squares of order 3, 5, 7'''
    print(
        fTable(__doc__ + ':')(lambda x: '\n' + repr(x))(
            showSquare
        )(magicSquare)([3, 5, 7])
    )


# GENERIC -------------------------------------------------

# applyN :: Int -> (a -> a) -> a -> a
def applyN(n):
    '''n applications of f.
       (Church numeral n).
    '''
    def go(f):
        return lambda x: reduce(
            lambda a, g: g(a), repeat(f, n), x
        )
    return lambda f: go(f)


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


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# drop :: Int -> [a] -> [a]
# drop :: Int -> String -> String
def drop(n):
    '''The sublist of xs beginning at
       (zero-based) index n.'''
    def go(xs):
        if isinstance(xs, (list, tuple, str)):
            return xs[n:]
        else:
            take(n)(xs)
            return xs
    return lambda xs: go(xs)


# enumFromThenTo :: Int -> Int -> Int -> [Int]
def enumFromThenTo(m):
    '''Integer values enumerated from m to n
       with a step defined by nxt-m.
    '''
    def go(nxt, n):
        d = nxt - m
        return range(m, n - 1 if d < 0 else 1 + n, d)
    return lambda nxt: lambda n: list(go(nxt, n))


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
    )


# transposed :: Matrix a -> Matrix a
def transposed(m):
    '''The rows and columns of the argument transposed.
       (The matrix containers and rows can be lists or tuples).
    '''
    if m:
        inner = type(m[0])
        z = zip(*m)
        return (type(m))(
            map(inner, z) if tuple != inner else z
        )
    else:
        return m


# DISPLAY -------------------------------------------------

# fTable :: String -> (a -> String) ->
#                     (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
                     f -> xs -> tabular string.
    '''
    def go(xShow, fxShow, f, xs):
        ys = [xShow(x) for x in xs]
        w = max(map(len, ys))
        return s + '\n' + '\n'.join(map(
            lambda x, y: y.rjust(w, ' ') + ' -> ' + fxShow(f(x)),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# indented :: Int -> String -> String
def indented(n):
    '''String indented by n multiples
       of four spaces
    '''
    return lambda s: (n * 4 * ' ') + s


# showSquare :: [[Int]] -> String
def showSquare(rows):
    '''Lines representing rows of lists.'''
    w = 1 + len(str(reduce(max, map(max, rows), 0)))
    return '\n' + '\n'.join(
        map(
            lambda row: indented(1)(''.join(
                map(lambda x: str(x).rjust(w, ' '), row)
            )),
            rows
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
