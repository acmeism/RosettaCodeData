'''Roman numerals decoded'''

from operator import mul
from functools import reduce
from collections import defaultdict
from itertools import accumulate, chain, cycle


# intFromRoman :: String -> Maybe Int
def intFromRoman(s):
    '''Just the integer represented by a Roman
       numeral string, or Nothing if any
       characters are unrecognised.
    '''
    dct = defaultdict(
        lambda: None,
        zip(
            'IVXLCDM',
            accumulate(chain([1], cycle([5, 2])), mul)
        )
    )

    def go(mb, x):
        '''Just a letter value added to or
           subtracted from a total, or Nothing
           if no letter value is defined.
        '''
        if None in (mb, x):
            return None
        else:
            r, total = mb
            return x, total + (-x if x < r else x)

    return bindMay(reduce(
        go,
        [dct[k.upper()] for k in reversed(list(s))],
        (0, 0)
    ))(snd)


# ------------------------- TEST -------------------------
def main():
    '''Testing a sample of dates.'''

    print(
        fTable(__doc__ + ':\n')(str)(
            maybe('(Contains unknown character)')(str)
        )(
            intFromRoman
        )([
            "MDCLXVI", "MCMXC", "MMVIII",
            "MMXVI", "MMXVIII", "MMZZIII"
        ])
    )


# ----------------------- GENERIC ------------------------

# bindMay (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
def bindMay(m):
    '''Injection operator for the Maybe monad.
       If m is Nothing, it is passed straight through.
       If m is Just(x), the result is an application
       of the (a -> Maybe b) function (mf) to x.'''
    return lambda mf: (
        m if None is m else mf(m)
    )


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if None is m else (
        f(m)
    )


# snd :: (a, b) -> b
def snd(ab):
    '''Second member of a pair.'''
    return ab[1]


# ---------------------- FORMATTING ----------------------

# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function ->
       fx display function -> f -> xs -> tabular string.
    '''
    def go(xShow, fxShow, f, xs):
        ys = [xShow(x) for x in xs]
        w = max(map(len, ys))
        return s + '\n' + '\n'.join(map(
            lambda x, y: (
                f'{y.rjust(w, " ")} -> {fxShow(f(x))}'
            ),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: (
        lambda xs: go(xShow, fxShow, f, xs)
    )


# MAIN ---
if __name__ == '__main__':
    main()
