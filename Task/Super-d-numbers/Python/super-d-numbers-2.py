'''Super-d numbers'''

from itertools import count, islice
from functools import reduce


# ------------------------ SUPER-D -------------------------

# super_d :: Int -> Either String [Int]
def super_d(d):
    '''Either a message, if d is out of range, or
       an infinite series of super_d numbers for d.
    '''
    if isinstance(d, int) and 1 < d < 10:
        ds = d * str(d)

        def p(x):
            return ds in str(d * x ** d)

        return Right(filter(p, count(2)))
    else:
        return Left(
            'Super-d is defined only for integers drawn from {2..9}'
        )


# ------------------------- TESTS --------------------------
# main :: IO ()
def main():
    '''Attempted sampling of first 10 values for d <- [1..6],
       where d = 1 is out of range.
    '''
    for v in map(
        lambda x: either(
            append(str(x) + ' :: ')
        )(
            compose(
                append('First 10 super-' + str(x) + ': '),
                showList
            )
        )(
            bindLR(
                super_d(x)
            )(compose(Right, take(10)))
        ),
        enumFromTo(1)(6)
    ): print(v)


# ------------------------ GENERIC -------------------------

# Left :: a -> Either a b
def Left(x):
    '''Constructor for an empty Either (option type) value
       with an associated string.
    '''
    return {'type': 'Either', 'Right': None, 'Left': x}


# Right :: b -> Either a b
def Right(x):
    '''Constructor for a populated Either (option type) value'''
    return {'type': 'Either', 'Left': None, 'Right': x}


# append (++) :: [a] -> [a] -> [a]
# append (++) :: String -> String -> String
def append(xs):
    '''A list or string formed by
       the concatenation of two others.
    '''
    def go(ys):
        return xs + ys
    return go


# bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
def bindLR(m):
    '''Either monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.
    '''
    def go(mf):
        return (
            mf(m.get('Right')) if None is m.get('Left') else m
        )
    return go


# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    def go(f, g):
        def fg(x):
            return f(g(x))
        return fg
    return reduce(go, fs, lambda x: x)


# either :: (a -> c) -> (b -> c) -> Either a b -> c
def either(fl):
    '''The application of fl to e if e is a Left value,
       or the application of fr to e if e is a Right value.
    '''
    return lambda fr: lambda e: fl(e['Left']) if (
        None is e['Right']
    ) else fr(e['Right'])


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]
    '''
    return lambda n: range(m, 1 + n)


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(str(x) for x in xs) + ']'


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    def go(xs):
        return islice(xs, n)
    return go


# MAIN ---
if __name__ == '__main__':
    main()
