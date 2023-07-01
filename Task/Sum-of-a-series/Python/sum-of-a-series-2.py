'''The sum of a series'''

from functools import reduce


# seriesSumA :: (a -> b) -> [a] -> b
def seriesSumA(f):
    '''The sum of the map of f over xs.'''
    return lambda xs: sum(map(f, xs))


# seriesSumB :: (a -> b) -> [a] -> b
def seriesSumB(f):
    '''Folding acc + f(x) over xs where acc begins at 0.'''
    return lambda xs: reduce(
        lambda a, x: a + f(x), xs, 0
    )


# TEST ----------------------------------------------------
# main:: IO ()
def main():
    '''Summing 1/x^2 over x = 1..1000'''

    def f(x):
        return 1 / (x * x)

    print(
        fTable(
            __doc__ + ':\n' + '(1/x^2 over x = 1..1000)'
        )(lambda f: '\tby ' + f.__name__)(str)(
            lambda g: g(f)(enumFromTo(1)(1000))
        )([seriesSumA, seriesSumB])
    )


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# fTable :: String -> (a -> String) ->
#                     (b -> String) ->
#        (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + (
                ' -> '
            ) + fxShow(f(x)) for x in xs
        ])
    return lambda xShow: lambda fxShow: (
        lambda f: lambda xs: go(
            xShow, fxShow, f, xs
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
