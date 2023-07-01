'''Jaro distance between two strings'''

from functools import reduce
import itertools


# --------------------- JARO FUNCTION ----------------------

# jaro :: String -> String -> Float
def jaro(x):
    '''The Jaro distance between two strings.'''
    def go(s1, s2):
        m, t = ap(compose(Tuple, len))(
            transpositionSum
        )(matches(s1, s2))
        return 0 if 0 == m else (
            (1 / 3) * ((m / len(s1)) + (
                m / len(s2)
            ) + ((m - t) / m))
        )
    return lambda y: go(x, y)


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Sample word pairs'''

    print(
        fTable('Jaro distances:\n')(str)(
            showPrecision(3)
        )(
            uncurry(jaro)
        )([
            ("DWAYNE", "DUANE"),
            ("MARTHA", "MARHTA"),
            ("DIXON", "DICKSONX"),
            ("JELLYFISH", "SMELLYFISH")
        ])
    )


# ----------------- JARO HELPER FUNCTIONS ------------------

# transpositionSum :: [(Int, Char)] -> Int
def transpositionSum(xs):
    '''A count of the transpositions in xs.'''
    def f(a, xy):
        x, y = xy
        return 1 + a if fst(x) > fst(y) else a
    return reduce(f, zip(xs, xs[1:]), 0)


# matches :: String -> String -> [(Int, Char)]
def matches(s1, s2):
    '''A list of (Index, Char) correspondences
       between the two strings s1 and s2.'''

    [(_, xs), (l2, ys)] = sorted(map(
        ap(compose(Tuple, len))(list), [s1, s2]
    ))
    r = l2 // 2 - 1

    # match :: (Int, (Char, Int)) -> (Int, Char)
    def match(a, nc):
        n, c = nc
        offset = max(0, n - (1 + r))

        def indexChar(x):
            return a + [(offset + x, c)]

        return maybe(a)(indexChar)(
            elemIndex(c)(
                drop(offset)(take(n + r)(ys))
            )
        )
    return reduce(match, enumerate(xs), [])


# ------------------- GENERIC FUNCTIONS --------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.
       Wrapper containing the result of a computation.
    '''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return {'type': 'Maybe', 'Nothing': True}


# Tuple (,) :: a -> b -> (a, b)
def Tuple(x):
    '''Constructor for a pair of values,
       possibly of two different types.
    '''
    def go(y):
        return (
            x + (y,)
        ) if isinstance(x, tuple) else (x, y)
    return go


# ap :: (a -> b -> c) -> (a -> b) -> a -> c
def ap(f):
    '''Applicative instance for functions.
    '''
    def go(g):
        def fxgx(x):
            return f(x)(
                g(x)
            )
        return fxgx
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


# drop :: Int -> [a] -> [a]
# drop :: Int -> String -> String
def drop(n):
    '''The sublist of xs beginning at
       (zero-based) index n.
    '''
    def go(xs):
        if isinstance(xs, (list, tuple, str)):
            return xs[n:]
        else:
            take(n)(xs)
            return xs
    return go


# elemIndex :: Eq a => a -> [a] -> Maybe Int
def elemIndex(x):
    '''Just the index of the first element in xs
       which is equal to x,
       or Nothing if there is no such element.
    '''
    def go(xs):
        try:
            return Just(xs.index(x))
        except ValueError:
            return Nothing()
    return go


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if (
        None is m or m.get('Nothing')
    ) else f(m.get('Just'))


# showPrecision Int -> Float -> String
def showPrecision(n):
    '''A string showing a floating point number
       at a given degree of precision.'''
    return lambda x: str(round(x, n))


# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
       f -> xs -> tabular string.
    '''
    def gox(xShow):
        def gofx(fxShow):
            def gof(f):
                def goxs(xs):
                    ys = [xShow(x) for x in xs]
                    w = max(map(len, ys))

                    def arrowed(x, y):
                        return y.rjust(w, ' ') + (
                            ' -> ' + fxShow(f(x))
                        )
                    return s + '\n' + '\n'.join(
                        map(arrowed, xs, ys)
                    )
                return goxs
            return gof
        return gofx
    return gox


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    islice = itertools.islice

    def go(xs):
        return (
            xs[0:n]
            if isinstance(xs, (list, tuple))
            else list(islice(xs, n))
        )
    return go


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    '''A function over a tuple derived from a curried function.'''
    return lambda xy: f(xy[0])(
        xy[1]
    )


# MAIN ---
if __name__ == '__main__':
    main()
