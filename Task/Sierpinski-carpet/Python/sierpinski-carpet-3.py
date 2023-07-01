'''Iterations of the Sierpinski carpet'''

from itertools import chain, islice
from inspect import signature
from operator import add


# sierpinskiCarpet :: Int -> [String]
def sierpinskiCarpet(n):
    '''A string representing the nth
       iteration of a Sierpinski carpet.
    '''
    f = zipWith(add)
    g = flip(f)

    # weave :: [String] -> [String]
    def weave(xs):
        return bind([
            xs,
            [' ' * len(s) for s in xs],
            xs
        ])(compose(g(xs))(f(xs)))

    return index(
        iterate(weave)(['▓▓'])
    )(n)


# TEST ----------------------------------------------------
def main():
    '''Test iteration of the Sierpinski carpet'''

    levels = enumFromTo(0)(3)
    t = ' ' * (
        len(' -> ') +
        max(map(compose(len)(str), levels))
    )
    print(
        fTable(__doc__ + ':')(lambda x: '\n' + str(x))(
            lambda xs: xs[0] + '\n' + (
                unlines(map(lambda x: t + x, xs[1:])))
        )
        (sierpinskiCarpet)(levels)
    )


# GENERIC -------------------------------------------------

# bind (>>=) :: [a] -> (a -> [b]) -> [b]
def bind(xs):
    '''List monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.'''
    return lambda f: list(chain.from_iterable(
        map(f, xs)
    ))


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# flip :: (a -> b -> c) -> b -> a -> c
def flip(f):
    '''The (curried or uncurried) function f with its
       arguments reversed.'''
    if 1 < len(signature(f).parameters):
        return lambda a, b: f(b, a)
    else:
        return lambda a: lambda b: f(b)(a)


# index (!!) :: [a] -> Int -> a
def index(xs):
    '''Item at given (zero-based) index.'''
    return lambda n: None if 0 > n else (
        xs[n] if (
            hasattr(xs, "__getitem__")
        ) else next(islice(xs, n, None))
    )


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
    return lambda x: go(x)


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
        map(f, xs, ys)
    )


# OUTPUT FORMATTING ---------------------------------------

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


# MAIN ---
if __name__ == '__main__':
    main()
