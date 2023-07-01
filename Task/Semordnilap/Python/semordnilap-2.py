'''Dictionary words paired by equivalence under reversal'''

from functools import (reduce)
from itertools import (chain)
import urllib.request


# semordnilaps :: [String] -> [String]
def semordnilaps(xs):
    '''The subset of words in a list which
       are paired (by equivalence under reversal)
       with other words in that list.
    '''
    def go(tpl, w):
        (s, ws) = tpl
        if w[::-1] in s:
            return (s, ws + [w])
        else:
            s.add(w)
            return (s, ws)
    return reduce(go, xs, (set(), []))[1]


# TEST ----------------------------------------------------
def main():
    '''Test'''

    url = 'http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'
    ws = semordnilaps(
        urllib.request.urlopen(
            url
        ).read().splitlines()
    )
    print(
        fTable(
            __doc__ + ':\n\n(longest of ' +
            str(len(ws)) + ' in ' + url + ')\n'
        )(snd)(fst)(identity)(
            sorted(
                concatMap(
                    lambda x: (
                        lambda s=x.decode('utf8'): [
                            (s, s[::-1])
                        ] if 4 < len(x) else []
                    )()
                )(ws),
                key=compose(len)(fst),
                reverse=True
            )
        )
    )


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
    )


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


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# identity :: a -> a
def identity(x):
    '''The identity function.'''
    return x


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


if __name__ == '__main__':
    main()
