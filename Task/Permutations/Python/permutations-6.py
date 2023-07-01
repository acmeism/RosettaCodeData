'''Permutations of a list, string or tuple'''

from functools import (reduce)
from itertools import (chain)


# permutations :: [a] -> [[a]]
def permutations(xs):
    '''Type-preserving permutations of xs.
    '''
    ps = reduce(
        lambda a, x: concatMap(
            lambda xs: (
                xs[n:] + [x] + xs[0:n] for n in range(0, 1 + len(xs)))
        )(a),
        xs, [[]]
    )
    t = type(xs)
    return ps if list == t else (
        [''.join(x) for x in ps] if str == t else [
            t(x) for x in ps
        ]
    )


# TEST ----------------------------------------------------

# main :: IO ()
def main():
    '''Permutations of lists, strings and tuples.'''

    print(
        fTable(__doc__ + ':\n')(repr)(showList)(
            permutations
        )([
            [1, 2, 3],
            'abc',
            (1, 2, 3),
        ])
    )


# GENERIC -------------------------------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
    )


# FORMATTING ----------------------------------------------

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


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(showList(x) for x in xs) + ']' if (
        isinstance(xs, list)
    ) else repr(xs)


# MAIN ---
if __name__ == '__main__':
    main()
