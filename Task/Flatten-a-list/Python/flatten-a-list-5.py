'''Flatten a nested list'''

from itertools import (chain)


# ----------------------- FLATTEN ------------------------

# flatten :: NestedList a -> [a]
def flatten(x):
    '''A list of atomic values resulting from fully
       flattening an arbitrarily nested list.
    '''
    return concatMap(flatten)(x) if (
        isinstance(x, list)
    ) else [x]


# ------------------------- TEST -------------------------
def main():
    '''Test: flatten an arbitrarily nested list.
    '''
    print(
        fTable(__doc__ + ':')(showList)(showList)(
            flatten
        )([
            [[[]]],
            [[1, 2, 3]],
            [[1], [[2]], [[[3, 4]]]],
            [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]
        ])
    )


# ----------------------- GENERIC ------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


# fTable :: String -> (a -> String) ->
#                     (b -> String) ->
#        (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function ->
                 fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + (' -> ') + fxShow(f(x))
            for x in xs
        ])
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(str(x) for x in xs) + ']'


if __name__ == '__main__':
    main()
