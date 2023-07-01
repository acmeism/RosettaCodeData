'''Bell numbers'''

from itertools import accumulate, chain, islice
from operator import add, itemgetter
from functools import reduce


# bellNumbers :: [Int]
def bellNumbers():
    '''Bell or exponential numbers.
       A000110
    '''
    return map(itemgetter(0), bellTriangle())


# bellTriangle :: [[Int]]
def bellTriangle():
    '''Bell triangle.'''
    return map(
        itemgetter(1),
        iterate(
            compose(
                bimap(last)(identity),
                list, uncurry(scanl(add))
            )
        )((1, [1]))
    )


# ------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Tests'''
    showIndex = compose(repr, succ, itemgetter(0))
    showValue = compose(repr, itemgetter(1))
    print(
        fTable(
            'First fifteen Bell numbers:'
        )(showIndex)(showValue)(identity)(list(
            enumerate(take(15)(bellNumbers()))
        ))
    )

    print('\nFiftieth Bell number:')
    bells = bellNumbers()
    drop(49)(bells)
    print(
        next(bells)
    )

    print(
        fTable(
            "\nFirst 10 rows of Bell's triangle:"
        )(showIndex)(showValue)(identity)(list(
            enumerate(take(10)(bellTriangle()))
        ))
    )


# ------------------------ GENERIC ------------------------

# bimap :: (a -> b) -> (c -> d) -> (a, c) -> (b, d)
def bimap(f):
    '''Tuple instance of bimap.
       A tuple of the application of f and g to the
       first and second values respectively.
    '''
    def go(g):
        def gox(x):
            return (f(x), g(x))
        return gox
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
    return reduce(go, fs, identity)


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
                        return y.rjust(w, ' ') + ' -> ' + fxShow(f(x))
                    return s + '\n' + '\n'.join(
                        map(arrowed, xs, ys)
                    )
                return goxs
            return gof
        return gofx
    return gox


# identity :: a -> a
def identity(x):
    '''The identity function.'''
    return x


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


# last :: [a] -> a
def last(xs):
    '''The last element of a non-empty list.'''
    return xs[-1]


# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but returns a succession of
       intermediate values, building from the left.
    '''
    def go(a):
        def g(xs):
            return accumulate(chain([a], xs), f)
        return g
    return go


# succ :: Enum a => a -> a
def succ(x):
    '''The successor of a value.
       For numeric types, (1 +).
    '''
    return 1 + x


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    def go(xs):
        return (
            xs[0:n]
            if isinstance(xs, (list, tuple))
            else list(islice(xs, n))
        )
    return go


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    '''A function over a tuple,
       derived from a curried function.
    '''
    def go(tpl):
        return f(tpl[0])(tpl[1])
    return go


# MAIN ---
if __name__ == '__main__':
    main()
