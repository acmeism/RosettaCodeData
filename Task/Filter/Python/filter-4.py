'''Functional filtering - by descending generality and increasing brevity'''

from functools import (reduce)
from itertools import (chain)
import inspect
import re


def f1(xs):
    '''Catamorphism: fold / reduce.
       See [The expressiveness and universality of fold]
       (http://www.cs.nott.ac.uk/~pszgmh/fold.pdf)'''
    return reduce(lambda a, x: a + [x] if even(x) else a, xs, [])


def f2(xs):
    '''List monad bind/inject operator (concatMap combined with
       an (a -> [b]) function which wraps its result in a
       possibly empty list). This is the universal abstraction
       which underlies list comprehensions.'''
    return concatMap(lambda x: [x] if even(x) else [])(xs)


def f3(xs):
    '''Built-in syntactic sugar for list comprehensions.
       Convenient, and encouraged as 'Pythonic',
       but less general and expressive than a fold.'''
    return (x for x in xs if even(x))


def f4(xs):
    '''Built-in filter function'''
    return filter(even, xs)


def main():
    '''Tests'''
    xs = enumFromTo(0)(10)
    print(
        tabulated(showReturn)(
            'By descending generality and increasing brevity:\n'
        )(
            lambda f: list(f(xs))
        )([f1, f2, f3, f4])
    )


# GENERIC -------------------------------------------------


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''Concatenated list over which a function has been mapped.
       The list monad can be derived by using a function of the type
       (a -> [b]) which wraps its output in list
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# even :: Int -> Bool
def even(x):
    '''Predicate'''
    return 0 == x % 2


# showReturn :: (a -> b) -> String
def showReturn(f):
    '''Stringification of final (return) expression in function body.'''
    return re.split('return ', inspect.getsource(f))[-1].strip()


# tabulated :: (a -> String) -> String -> (a -> b) -> [a] -> String
def tabulated(fShow):
    '''heading -> function -> input List -> tabulated output string'''
    def go(s, f, xs):
        w = max(len(fShow(x)) for x in xs)
        return s + '\n' + '\n'.join([
            fShow(x).rjust(w, ' ') +
            ' -> ' + str(f(x)) for x in xs
        ])
    return lambda s: lambda f: lambda xs: go(s, f, xs)


if __name__ == '__main__':
    main()
