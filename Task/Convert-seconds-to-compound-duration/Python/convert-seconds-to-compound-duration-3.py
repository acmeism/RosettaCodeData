'''Compound duration'''

from functools import reduce
from itertools import chain


# compoundDurationFromUnits :: [Num] -> [String] -> Num -> [(Num, String)]
def compoundDurationFromUnits(qs):
    '''A list of compound string representions of a number n of time units,
       in terms of the multiples given in qs, and the labels given in ks.
    '''
    return lambda ks: lambda n: list(
        chain.from_iterable(map(
            lambda v, k: [(v, k)] if 0 < v else [],
            mapAccumR(
                lambda a, x: divmod(a, x) if 0 < x else (1, a)
            )(n)(qs)[1],
            ks
        ))
    )


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Tests of various durations, with a
       particular set of units and labels.
    '''

    print(
        fTable('Compound durations from numbers of seconds:\n')(str)(
            quoted("'")
        )(
            lambda n: ', '.join([
                str(v) + ' ' + k for v, k in
                compoundDurationFromUnits([0, 7, 24, 60, 60])(
                    ['wk', 'd', 'hr', 'min', 'sec']
                )(n)
            ])
        )([7259, 86400, 6000000])
    )


# -------------------------GENERIC-------------------------

# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
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


# mapAccumR :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
def mapAccumR(f):
    '''A tuple of an accumulation and a list derived by a combined
       map and fold, with accumulation from right to left.
    '''
    def go(a, x):
        acc, y = f(a[0], x)
        return (acc, [y] + a[1])
    return lambda acc: lambda xs: (
        reduce(go, reversed(xs), (acc, []))
    )


# quoted :: Char -> String -> String
def quoted(c):
    '''A string flanked on both sides
       by a specified quote character.
    '''
    return lambda s: c + s + c


# MAIN ---
if __name__ == '__main__':
    main()
