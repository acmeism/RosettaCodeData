'''Application of a given function, repeated N times'''

from itertools import repeat
from functools import reduce
from inspect import getsource


# applyN :: Int -> (a -> a) -> a -> a
def applyN(n):
    '''n compounding applications of the supplied
       function f. Equivalent to Church numeral n.
    '''
    def go(f):
        return lambda x: reduce(
            lambda a, g: g(a), repeat(f, n), x
        )
    return lambda f: go(f)


# MAIN ----------------------------------------------------
def main():
    '''Tests - compounding repetition
       of function application.
    '''
    def f(x):
        return x + 'Example\n'

    def g(x):
        return 2 * x

    def h(x):
        return 1.05 * x

    print(
        fTable(__doc__ + ':')(
            lambda fx: '\nRepeated * 3:\n (' + (
                getsource(fst(fx)).strip() + ')(' +
                repr(snd(fx)) + ')'
            )
        )(str)(
            liftA2(applyN(3))(fst)(snd)
        )([(f, '\n'), (g, 1), (h, 100)])
    )


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# liftA2 :: (a0 -> b -> c) -> (a -> a0) -> (a -> b) -> a -> c
def liftA2(op):
    '''Lift a binary function to a composition
       over two other functions.
       liftA2 (*) (+ 2) (+ 3) 7 == 90
    '''
    def go(f, g):
        return lambda x: op(
            f(x)
        )(g(x))
    return lambda f: lambda g: go(f, g)


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


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
