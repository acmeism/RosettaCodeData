'''Sierpinski triangle'''

from functools import reduce
from operator import add


# sierpinski :: Int -> String
def sierpinski(n):
    '''Nth iteration of a Sierpinksi triangle.'''
    def go(xs, i):
        s = ' ' * (2 ** i)
        return concatMap(lambda x: [s + x + s])(xs) + (
            concatMap(lambda x: [x + ' ' + x])(xs)
        )
    return '\n'.join(reduce(go, range(n), '*'))


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list or string over which a function f
       has been mapped.
       The list monad can be derived by using an (a -> [b])
       function which wraps its output in a list (using an
       empty list to represent computational failure).
    '''
    return lambda xs: (
        reduce(add, map(f, xs), [])
    )


print(sierpinski(4))
