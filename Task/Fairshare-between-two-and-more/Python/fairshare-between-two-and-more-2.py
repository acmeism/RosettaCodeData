'''Fairshare between two and more'''

from itertools import count, islice
from functools import reduce


# thueMorse :: Int -> [Int] -> [Int]
def thueMorse(base):
    '''Thue-Morse sequence for a given base.'''
    return fmapNext(baseDigitsSumModBase(base))(
        count(0)
    )


# baseDigitsSumModBase :: Int -> Int -> Int
def baseDigitsSumModBase(base):
    '''For any integer n, the sum of its digits
       in a given base, modulo that base.
    '''
    def go(n):
        return sum(unfoldl(
            lambda x: Just(divmod(x, base)) if 0 < x else Nothing()
        )(n)) % base

    return go


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''First 25 fairshare terms for a given number of players'''

    print(
        fTable(
            main.__doc__ + ':\n'
        )(repr)(
            lambda xs: '[' + ','.join(
                [str(x).rjust(2, ' ') for x in xs]
            ) + ' ]'
        )(
            compose(take(25), thueMorse)
        )([2, 3, 5, 11])
    )


# ------------------------ GENERIC -------------------------

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
    def go(f, g):
        def fg(x):
            return f(g(x))
        return fg
    return reduce(go, fs, identity)


# fmapNext <$> :: (a -> b) -> Iter [a] -> Iter [b]
def fmapNext(f):
    '''A function f mapped over a
       possibly non-finite iterator.
    '''
    def go(g):
        v = next(g, None)
        while None is not v:
            yield f(v)
            v = next(g, None)
    return go


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

# identity :: a -> a
def identity(x):
    '''The identity function.'''
    return x


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
    )


# unfoldl(lambda x: Just(((x - 1), x)) if 0 != x else Nothing())(10)
# -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
def unfoldl(f):
    '''Dual to reduce or foldl.
       Where these reduce a list to a summary value, unfoldl
       builds a list from a seed value.
       Where f returns Just(a, b), a is appended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns Nothing, the completed list is returned.
    '''
    def go(v):
        x, r = v, v
        xs = []
        while True:
            mb = f(x)
            if mb['Nothing']:
                return xs
            else:
                x, r = mb['Just']
                xs.insert(0, r)
        return xs
    return go


# MAIN ---
if __name__ == '__main__':
    main()
