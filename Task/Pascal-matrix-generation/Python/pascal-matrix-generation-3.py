'''Pascal matrix generation'''

from functools import reduce
from itertools import chain
from operator import add


# pascalMatrix :: Int -> ((Int, Int) -> (Int, Int)) -> [[Int]]
def pascalMatrix(n):
    '''Pascal S-, L-, or U- matrix of order n.
    '''
    return lambda f: chunksOf(n)(list(map(
        compose(binomialCoefficent, f),
        tupleRange((0, 0), (n, n))
    )))


# binomialCoefficent :: (Int, Int) -> Int
def binomialCoefficent(nk):
    '''The binomial coefficient of the tuple (n, k).
    '''
    n, k = nk

    def go(a, x):
        return a * (n - x + 1) // x
    return reduce(go, enumFromTo(1)(k), 1)


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Pascal S-, L-, and U- matrices of order 5.
    '''
    order = 5
    for k, f in [
            ('Symmetric', lambda ab: (add(*ab), ab[1])),
            ('Lower', identity),
            ('Upper', swap)
    ]:
        print(k + ':')
        print(showMatrix(
            pascalMatrix(order)(f)
        ))
        print()


# --------------------REUSABLE GENERICS--------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    return lambda x: reduce(
        lambda a, f: f(a),
        fs[::-1], x
    )


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    return lambda n: range(m, 1 + n)


# identity :: a -> a
def identity(x):
    '''The identity function.'''
    return x


# showMatrix :: [[Int]] -> String
def showMatrix(xs):
    '''String representation of xs
       as a matrix.
    '''
    def go():
        rows = [[str(x) for x in row] for row in xs]
        w = max(map(len, chain.from_iterable(rows)))
        return unlines(
            unwords(k.rjust(w, ' ') for k in row)
            for row in rows
        )
    return go() if xs else ''


# swap :: (a, b) -> (b, a)
def swap(tpl):
    '''The swapped components of a pair.'''
    return tpl[1], tpl[0]


# tupleRange :: (Int, Int) -> (Int, Int) -> [(Int, Int)]
def tupleRange(lowerTuple, upperTuple):
    '''Range of (Int, Int) tuples from
       lowerTuple to upperTuple.
    '''
    l1, l2 = lowerTuple
    u1, u2 = upperTuple
    return [
        (i1, i2) for i1 in range(l1, u1)
        for i2 in range(l2, u2)
    ]


# unlines :: [String] -> String
def unlines(xs):
    '''A single string formed by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# unwords :: [String] -> String
def unwords(xs):
    '''A space-separated string derived
       from a list of words.
    '''
    return ' '.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
