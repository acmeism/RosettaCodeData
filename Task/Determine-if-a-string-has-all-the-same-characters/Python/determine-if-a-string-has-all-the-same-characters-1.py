'''Determine if a string has all the same characters'''

from itertools import groupby


# firstDifferingCharLR :: String -> Either String Dict
def firstDifferingCharLR(s):
    '''Either a message reporting that no character changes were
       seen, or a dictionary with details of the  first character
       (if any) that differs from that at the head of the string.
    '''
    def details(xs):
        c = xs[1][0]
        return {
            'char': repr(c),
            'hex': hex(ord(c)),
            'index': s.index(c),
            'total': len(s)
        }
    xs = list(groupby(s))
    return Right(details(xs)) if 1 < len(xs) else (
        Left('Total length ' + str(len(s)) + ' - No character changes.')
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test of 7 strings'''

    print(fTable('First, if any, points of difference:\n')(repr)(
        either(identity)(
            lambda dct: dct['char'] + ' (' + dct['hex'] +
            ') at character ' + str(1 + dct['index']) +
            ' of ' + str(dct['total']) + '.'
        )
    )(firstDifferingCharLR)([
        '',
        '   ',
        '2',
        '333',
        '.55',
        'tttTTT',
        '4444 444'
    ]))


# GENERIC -------------------------------------------------

# either :: (a -> c) -> (b -> c) -> Either a b -> c
def either(fl):
    '''The application of fl to e if e is a Left value,
       or the application of fr to e if e is a Right value.
    '''
    return lambda fr: lambda e: fl(e['Left']) if (
        None is e['Right']
    ) else fr(e['Right'])


# identity :: a -> a
def identity(x):
    '''The identity function.'''
    return x


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


# Left :: a -> Either a b
def Left(x):
    '''Constructor for an empty Either (option type) value
       with an associated string.
    '''
    return {'type': 'Either', 'Right': None, 'Left': x}


# Right :: b -> Either a b
def Right(x):
    '''Constructor for a populated Either (option type) value'''
    return {'type': 'Either', 'Left': None, 'Right': x}


# MAIN ---
if __name__ == '__main__':
    main()
