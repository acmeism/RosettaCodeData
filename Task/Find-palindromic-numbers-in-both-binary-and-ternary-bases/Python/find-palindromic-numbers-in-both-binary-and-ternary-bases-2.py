'''Numbers with palindromic digit strings in both binary and ternary'''

from itertools import (islice)


# palinBoth :: Generator [Int]
def palinBoth():
    '''Non finite stream of dually palindromic integers.'''
    yield 0, '0', '0'
    ibt = 1, '1', '1'

    yield ibt
    while True:
        ibt = until(isBoth)(psucc)(psucc(ibt))
        yield int(ibt[2], 3), ibt[1], ibt[2]


# isBoth :: (Int, String, String) -> Bool
def isBoth(ibt):
    '''True if the binary string is palindromic (as
       the ternary string is already known to be).
    '''
    b = ibt[1]
    return b == b[::-1]


# psucc :: (Int, String, String) -> (Int, String, String)
def psucc(ibt):
    '''The next triple of index, binary
       and (palindromic) ternary string
    '''
    d = 1 + ibt[0]
    s = showBase3(d)
    pal = s + '1' + s[::-1]
    return d, bin(int(pal, 3))[2:], pal


# showBase3 :: Int -> String
def showBase3(n):
    '''Ternary digit string for integer n.'''
    return showIntAtBase(3)(
        lambda i: '012'[i]
    )(n)('')


# ------------------------- TEST -------------------------
def main():
    '''Integers with palindromic digits in
       both binary and ternary bases.
    '''

    xs = take(6)(palinBoth())
    d, b, t = xs[-1]
    bw = len(b)
    tw = len(t)

    print(
        fTable(
            label('rjust')(('Decimal', len(str(d)))) +
            ''.join(map(
                label('center'),
                [('Binary', bw), ('Ternary', tw)]
            )) + '\n'
        )(compose(str)(fst))(
            lambda p: p[1].center(bw, ' ') +
            '    ' + p[2].center(tw, ' ')
        )(identity)(xs)
    )


# ----------------------- GENERIC ------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# identity :: a -> a
def identity(x):
    '''The identity function.'''
    return x


# showIntAtBase :: Int -> (Int -> String) -> Int -> String -> String
def showIntAtBase(base):
    '''String representation of an integer in a given base,
       using a supplied function for the string representation
       of digits.
    '''
    def wrap(toChr, n, rs):
        def go(nd, r):
            n, d = nd
            r_ = toChr(d) + r
            return go(divmod(n, base), r_) if 0 != n else r_
        return 'unsupported base' if 1 >= base else (
            'negative number' if 0 > n else (
                go(divmod(n, base), rs))
        )
    return lambda toChr: lambda n: lambda rs: (
        wrap(toChr, n, rs)
    )


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    def go(xs):
        return (
            xs[0:n]
            if isinstance(xs, (list, tuple))
            else list(islice(xs, n))
        )
    return go


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f):
        def g(x):
            v = x
            while not p(v):
                v = f(v)
            return v
        return g
    return go


# ---------------------- FORMATTING ----------------------

# label :: Method String -> (String, Int)
def label(k):
    '''Stringification, using the named justification
       method (ljust|centre|rjust) of the label,
       and the specified amount of white space.
    '''
    def go(sw):
        s, w = sw
        return getattr(s, k)(w, ' ') + '    '
    return go


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
