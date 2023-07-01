'''Range consolidation'''

from functools import reduce


# consolidated :: [(Float, Float)] -> [(Float, Float)]
def consolidated(xs):
    '''A consolidated list of
       [(Float, Float)] ranges.'''

    def go(abetc, xy):
        '''A copy of the accumulator abetc,
           with its head range ab either:
           1. replaced by or
           2. merged with
           the next range xy, or
           with xy simply prepended.'''
        if abetc:
            a, b = abetc[0]
            etc = abetc[1:]
            x, y = xy
            return [xy] + etc if y >= b else (   # ab replaced.
                [(x, b)] + etc if y >= a else (  # xy + ab merged.
                    [xy] + abetc                 # xy simply prepended.
                )
            )
        else:
            return [xy]

    def tupleSort(ab):
        a, b = ab
        return ab if a <= b else (b, a)

    return reduce(
        go,
        sorted(map(tupleSort, xs), reverse=True),
        []
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tests'''

    print(
        tabulated('Consolidation of numeric ranges:')(str)(str)(
            consolidated
        )([
            [(1.1, 2.2)],
            [(6.1, 7.2), (7.2, 8.3)],
            [(4, 3), (2, 1)],
            [(4, 3), (2, 1), (-1, -2), (3.9, 10)],
            [(1, 3), (-6, -1), (-4, -5), (8, 2), (-6, -6)]
        ])
    )


# GENERIC FUNCTIONS FOR DISPLAY ---------------------------


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        ])
    return lambda xShow: lambda fxShow: (
        lambda f: lambda xs: go(
            xShow, fxShow, f, xs
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
