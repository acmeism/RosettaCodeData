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
    def go(mb, x):
        '''Just a letter value added to or
           subtracted from a total, or Nothing
           if no letter value is defined.
        '''
        if mb.get('Nothing') or None is x:
            return Nothing()
        else:
            r, total = mb.get('Just')
            return Just((
                x,
                total + (-x if x < r else x)
            ))

    dct = defaultdict(
        lambda: None,
        zip(
            'IVXLCDM',
            accumulate(chain([1], cycle([5, 2])), mul)
        )
    )
    return bindMay(
        reduce(
            go,
            [dct[k.upper()] for k in reversed(list(s))],
            Just((0, 0))
        )
    )(compose(Just)(snd))


# TEST ----------------------------------------------------
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


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# bindMay (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
def bindMay(m):
    '''Injection operator for the Maybe monad.
       If m is Nothing, it is passed straight through.
       If m is Just(x), the result is an application
       of the (a -> Maybe b) function (mf) to x.'''
    return lambda mf: (
        m if m.get('Nothing') else mf(m.get('Just'))
    )


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if m.get('Nothing') else (
        f(m.get('Just'))
    )


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# FORMATTING ----------------------------------------------

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
