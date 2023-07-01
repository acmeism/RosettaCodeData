'''Flatten a list'''

from functools import (reduce)
from itertools import (chain)


def flatten(xs):
    '''A flat list of atomic values derived
       from a nested list.
    '''
    return reduce(
        lambda a, x: a + list(until(every(notList))(
            concatMap(pureList)
        )([x])),
        xs, []
    )


# TEST ----------------------------------------------------
def main():
    '''From nested list to flattened list'''

    print(main.__doc__ + ':\n\n')
    xs = [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]
    print(
        repr(xs) + ' -> ' + repr(flatten(xs))
    )


# GENERIC -------------------------------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
    )


# every :: (a -> Bool) -> [a] -> Bool
def every(p):
    '''True if p(x) holds for every x in xs'''
    def go(p, xs):
        return all(map(p, xs))
    return lambda xs: go(p, xs)


# notList :: a -> Bool
def notList(x):
    '''True if the value x is not a list.'''
    return not isinstance(x, list)


# pureList :: a -> [b]
def pureList(x):
    '''x if x is a list, othewise [x]'''
    return x if isinstance(x, list) else [x]


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


if __name__ == '__main__':
    main()
