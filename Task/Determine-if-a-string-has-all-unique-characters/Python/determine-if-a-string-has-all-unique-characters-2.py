'''Determine if a string has all unique characters'''

from functools import reduce


# duplicatedCharIndices :: String -> Maybe (Char, [Int])
def duplicatedCharIndices(s):
    '''Just the first duplicated character, and
       the indices of its occurrence, or
       Nothing if there are no duplications.
    '''
    def go(dct, ic):
        i, c = ic
        return dict(
            dct,
            **{c: dct[c] + [i] if c in dct else [i]}
        )
    duplicates = [
        (k, v) for (k, v)
        in reduce(go, enumerate(s), {}).items()
        if 1 < len(v)
    ]
    return Just(
        min(duplicates, key=compose(head, snd))
    ) if duplicates else Nothing()


# And another alternative here would be to fuse the 1 < len(v)
# filtering, and the min() search for the earliest duplicate,
# down to a single `earliestDuplication` fold:

# duplicatedCharIndices_ :: String -> Maybe (Char, [Int])
def duplicatedCharIndices_(s):
    '''Just the first duplicated character, and
       the indices of its occurrence, or
       Nothing if there are no duplications.
    '''
    def positionRecord(dct, ic):
        i, c = ic
        return dict(
            dct,
            **{c: dct[c] + [i] if c in dct else [i]}
        )

    def earliestDuplication(sofar, charPosns):
        c, indices = charPosns
        return (
            maybe(Just((c, indices)))(
                lambda kxs: Just((c, indices)) if (
                    # Earlier duplication ?
                    indices[0] < kxs[1][0]
                ) else sofar
            )(sofar)
        ) if 1 < len(indices) else sofar

    return reduce(
        earliestDuplication,
        reduce(
            positionRecord,
            enumerate(s),
            {}
        ).items(),
        Nothing()
    )


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
        )(maybe('None')(showDuplicate))(duplicatedCharIndices_)([
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


# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    return lambda x: reduce(
        lambda a, f: f(a),
        fs[::-1], x
    )


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


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# MAIN ---
if __name__ == '__main__':
    main()
