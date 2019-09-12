'''Character counting as a fold'''

from functools import reduce
from itertools import repeat
from os.path import expanduser


# charCounts :: String -> Dict Char Int
def charCounts(s):
    '''A dictionary of
       (character, frequency) mappings
    '''
    def tally(dct, c):
        dct[c] = 1 + dct[c] if c in dct else 1
        return dct
    return reduce(tally, list(s), {})


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Listing in descending order of frequency.'''

    print(
        tabulated(
            'Descending order of frequency:\n'
        )(compose(repr)(fst))(compose(str)(snd))(
            5
        )(stet)(
            sorted(
                charCounts(
                    readFile('~/Code/charCount/readme.txt')
                ).items(),
                key=swap,
                reverse=True
            )
        )
    )


# GENERIC -------------------------------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n,
       subdividing the contents of xs.
       Where the length of xs is not evenly divible,
       the final list will be shorter than n.'''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path
       derived by expanding any ~ in fp.'''
    with open(expanduser(fp), 'r', encoding='utf-8') as f:
        return f.read()


# paddedMatrix :: a -> [[a]] -> [[a]]
def paddedMatrix(v):
    ''''A list of rows padded to equal length
        (where needed) with instances of the value v.'''
    def go(rows):
        return paddedRows(
            len(max(rows, key=len))
        )(v)(rows)
    return lambda rows: go(rows) if rows else []


# paddedRows :: Int -> a -> [[a]] -[[a]]
def paddedRows(n):
    '''A list of rows padded (but never truncated)
       to length n with copies of value v.'''
    def go(v, xs):
        def pad(x):
            d = n - len(x)
            return (x + list(repeat(v, d))) if 0 < d else x
        return list(map(pad, xs))
    return lambda v: lambda xs: go(v, xs) if xs else []


# showColumns :: Int -> [String] -> String
def showColumns(n):
    '''A column-wrapped string
       derived from a list of rows.'''
    def go(xs):
        def fit(col):
            w = len(max(col, key=len))

            def pad(x):
                return x.ljust(4 + w, ' ')
            return ''.join(map(pad, col)).rstrip()

        q, r = divmod(len(xs), n)
        return '\n'.join(map(
            fit,
            zip(*paddedMatrix('')(
                chunksOf(q + int(bool(r)))(xs)
            ))
        ))
    return lambda xs: go(xs)


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# stet :: a -> a
def stet(x):
    '''The identity function.
       The usual 'id' is reserved in Python.'''
    return x


# swap :: (a, b) -> (b, a)
def swap(tpl):
    '''The swapped components of a pair.'''
    return (tpl[1], tpl[0])


# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        Int ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
          number of columns -> f -> value list -> tabular string.'''
    def go(xShow, fxShow, intCols, f, xs):
        def mxw(fshow, g):
            return max(map(compose(len)(fshow), map(g, xs)))
        w = mxw(xShow, lambda x: x)
        fw = mxw(fxShow, f)
        return s + '\n' + showColumns(intCols)([
            xShow(x).rjust(w, ' ') + ' -> ' + (
                fxShow(f(x)).rjust(fw, ' ')
            )
            for x in xs
        ])
    return lambda xShow: lambda fxShow: lambda nCols: (
        lambda f: lambda xs: go(
            xShow, fxShow, nCols, f, xs
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
