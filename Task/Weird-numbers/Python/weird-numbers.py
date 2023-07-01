'''Weird numbers'''

from itertools import chain, count, islice, repeat
from functools import reduce
from math import sqrt
from time import time


# weirds :: Gen [Int]
def weirds():
    '''Non-finite stream of weird numbers.
       (Abundant, but not semi-perfect)
       OEIS: A006037
    '''
    def go(n):
        ds = descPropDivs(n)
        d = sum(ds) - n
        return [n] if 0 < d and not hasSum(d, ds) else []
    return concatMap(go)(count(1))


# hasSum :: Int -> [Int] -> Bool
def hasSum(n, xs):
    '''Does any subset of xs sum to n ?
       (Assuming xs to be sorted in descending
       order of magnitude)'''
    def go(n, xs):
        if xs:
            h, t = xs[0], xs[1:]
            if n < h:  # Head too big. Forget it. Tail ?
                return go(n, t)
            else:
                # The head IS the target ?
                # Or the tail contains a sum for the
                # DIFFERENCE between the head and the target ?
                # Or the tail contains some OTHER sum for the target ?
                return n == h or go(n - h, t) or go(n, t)
        else:
            return False
    return go(n, xs)


# descPropDivs :: Int -> [Int]
def descPropDivs(n):
    '''Descending positive divisors of n,
       excluding n itself.'''
    root = sqrt(n)
    intRoot = int(root)
    blnSqr = root == intRoot
    lows = [x for x in range(1, 1 + intRoot) if 0 == n % x]
    return [
        n // x for x in (
            lows[1:-1] if blnSqr else lows[1:]
        )
    ] + list(reversed(lows))


# --------------------------TEST---------------------------

# main :: IO ()
def main():
    '''Test'''

    start = time()
    n = 50
    xs = take(n)(weirds())

    print(
        (tabulated('First ' + str(n) + ' weird numbers:\n')(
            lambda i: str(1 + i)
        )(str)(5)(
            index(xs)
        )(range(0, n)))
    )
    print(
        '\nApprox computation time: ' +
        str(int(1000 * (time() - start))) + ' ms'
    )


# -------------------------GENERIC-------------------------

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


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list or string over which a function f
       has been mapped.
       The list monad can be derived by using an (a -> [b])
       function which wraps its output in a list (using an
       empty list to represent computational failure).
    '''
    return lambda xs: chain.from_iterable(map(f, xs))


# index (!!) :: [a] -> Int -> a
def index(xs):
    '''Item at given (zero-based) index.'''
    return lambda n: None if 0 > n else (
        xs[n] if (
            hasattr(xs, "__getitem__")
        ) else next(islice(xs, n, None))
    )


# paddedMatrix :: a -> [[a]] -> [[a]]
def paddedMatrix(v):
    ''''A list of rows padded to equal length
        (where needed) with instances of the value v.'''
    def go(rows):
        return paddedRows(
            len(max(rows, key=len))
        )(v)(rows)
    return lambda rows: go(rows) if rows else []


# paddedRows :: Int -> a -> [[a]] -[[a]]
def paddedRows(n):
    '''A list of rows padded (but never truncated)
       to length n with copies of value v.'''
    def go(v, xs):
        def pad(x):
            d = n - len(x)
            return (x + list(repeat(v, d))) if 0 < d else x
        return list(map(pad, xs))
    return lambda v: lambda xs: go(v, xs) if xs else []


# showColumns :: Int -> [String] -> String
def showColumns(n):
    '''A column-wrapped string
       derived from a list of rows.'''
    def go(xs):
        def fit(col):
            w = len(max(col, key=len))

            def pad(x):
                return x.ljust(4 + w, ' ')
            return ''.join(map(pad, col))

        q, r = divmod(len(xs), n)
        return unlines(map(
            fit,
            transpose(paddedMatrix('')(
                chunksOf(q + int(bool(r)))(
                    xs
                )
            ))
        ))
    return lambda xs: go(xs)


# succ :: Enum a => a -> a
def succ(x):
    '''The successor of a value. For numeric types, (1 +).'''
    return 1 + x if isinstance(x, int) else (
        chr(1 + ord(x))
    )


# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        Int ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
          number of columns -> f -> value list -> tabular string.'''
    def go(xShow, fxShow, intCols, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + showColumns(intCols)([
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        ])
    return lambda xShow: lambda fxShow: lambda nCols: (
        lambda f: lambda xs: go(
            xShow, fxShow, nCols, f, xs
        )
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


# transpose :: Matrix a -> Matrix a
def transpose(m):
    '''The rows and columns of the argument transposed.
       (The matrix containers and rows can be lists or tuples).'''
    if m:
        inner = type(m[0])
        z = zip(*m)
        return (type(m))(
            map(inner, z) if tuple != inner else z
        )
    else:
        return m


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.'''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


# MAIN ----------------------------------------------------
if __name__ == '__main__':
    main()
