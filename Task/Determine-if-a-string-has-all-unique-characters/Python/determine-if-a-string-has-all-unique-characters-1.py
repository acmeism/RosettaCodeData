'''Determine if a string has all unique characters'''

from itertools import groupby


# duplicatedCharIndices :: String -> Maybe (Char, [Int])
def duplicatedCharIndices(s):
    '''Just the first duplicated character, and
       the indices of its occurrence, or
       Nothing if there are no duplications.
    '''
    def go(xs):
        if 1 < len(xs):
            duplicates = list(filter(lambda kv: 1 < len(kv[1]), [
                (k, list(v)) for k, v in groupby(
                    sorted(xs, key=swap),
                    key=snd
                )
            ]))
            return Just(second(fmap(fst))(
                sorted(
                    duplicates,
                    key=lambda kv: kv[1][0]
                )[0]
            )) if duplicates else Nothing()
        else:
            return Nothing()
    return go(list(enumerate(s)))


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test over various strings.'''

    def showSample(s):
        return repr(s) + ' (' + str(len(s)) + ')'

    def showDuplicate(cix):
        c, ix = cix
        return repr(c) + (
            ' (' + hex(ord(c)) + ') at ' + repr(ix)
        )

    print(
        fTable('First duplicated character, if any:')(
            showSample
        )(maybe('None')(showDuplicate))(duplicatedCharIndices)([
            '', '.', 'abcABC', 'XYZ ZYX',
            '1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ'
        ])
    )


# FORMATTING ----------------------------------------------

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


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.
       Wrapper containing the result of a computation.
    '''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return {'type': 'Maybe', 'Nothing': True}


# fmap :: (a -> b) -> [a] -> [b]
def fmap(f):
    '''fmap over a list.
       f lifted to a function over a list.
    '''
    return lambda xs: [f(x) for x in xs]


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# head :: [a] -> a
def head(xs):
    '''The first element of a non-empty list.'''
    return xs[0] if isinstance(xs, list) else next(xs)


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if (
        None is m or m.get('Nothing')
    ) else f(m.get('Just'))


# second :: (a -> b) -> ((c, a) -> (c, b))
def second(f):
    '''A simple function lifted to a function over a tuple,
       with f applied only to the second of two values.
    '''
    return lambda xy: (xy[0], f(xy[1]))


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# swap :: (a, b) -> (b, a)
def swap(tpl):
    '''The swapped components of a pair.'''
    return (tpl[1], tpl[0])


# MAIN ---
if __name__ == '__main__':
    main()
