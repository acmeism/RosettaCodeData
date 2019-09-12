'''Range expansion'''

from functools import (reduce)


# rangeExpansion :: String -> [Int]
def rangeExpansion(s):
    '''List of integers expanded from a
       comma-delimited string of individual
       numbers and hyphenated ranges.
    '''
    def go(a, x):
        tpl = breakOn('-')(x[1:])
        r = tpl[1]
        return a + (
            [int(x)] if not r
            else enumFromTo(int(x[0] + tpl[0]))(
                int(r[1:])
            )
        )
    return reduce(go, s.split(','), [])


# TEST ----------------------------------------------------
def main():
    '''Expansion test'''

    print(
        fTable(__doc__ + ':')(
            lambda x: "\n'" + str(x) + "'"
        )(lambda x: '\n\n\t' + showList(x))(
            rangeExpansion
        )([
            '-6,-3--1,3-5,7-11,14,15,17-20'
        ])
    )


# GENERIC FUNCTIONS ---------------------------------------

# breakOn :: String -> String -> (String, String)
def breakOn(needle):
    '''A tuple of:
       1. the prefix of haystack before needle,
       2. the remainder of haystack, starting
          with needle.
    '''
    def go(haystack):
        xs = haystack.split(needle)
        return (xs[0], haystack[len(xs[0]):]) if (
            1 < len(xs)
        ) else (haystack, '')
    return lambda haystack: go(haystack) if (
        needle
    ) else None


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
        w = max(map(lambda x: len(xShow(x)), xs))
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


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(str(x) for x in xs) + ']'


# MAIN ---
if __name__ == '__main__':
    main()
