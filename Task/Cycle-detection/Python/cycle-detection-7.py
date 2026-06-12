'''Cycle detection without recursion.'''

from itertools import (chain, cycle, islice)
from operator import (eq)


# cycleFound :: Eq a => [a] -> Maybe ([a], Int, Int)
def cycleFound(xs):
    '''Just the first cycle found, with its length
       and start index, or Nothing if no cycle seen.
    '''
    return bind(cycleLength(xs))(
        lambda n: bind(
            findIndex(uncurry(eq))(zip(xs, xs[n:]))
        )(lambda iStart: Just(
            (xs[iStart:iStart + n], n, iStart)
        ))
    )


# cycleLength :: Eq a => [a] -> Maybe Int
def cycleLength(xs):
    '''Just the length of the first cycle found,
       or Nothing if no cycle seen.'''

    # f :: (Int, Int, Int, [Int]) -> (Int, Int, Int, [Int])
    def f(tpl):
        pwr, lng, x, ys = tpl
        y, *yt = ys
        return (2 * pwr, 1, y, yt) if (
            lng == pwr
        ) else (pwr, 1 + lng, x, yt)

    # p :: (Int, Int, Int, [Int]) -> Bool
    def p(tpl):
        _, _, x, ys = tpl
        return (not ys) or x == ys[0]

    if xs:
        _, lng, x, ys = until(p)(f)(
            (1, 1, xs[0], xs[1:])
        )
        return (
            Just(lng) if (x == ys[0]) else Nothing()
        ) if ys else Nothing()
    else:
        return Nothing()


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Reports of any cycle detection.'''

    print(
        fTable(
            'First cycle detected, if any:\n'
        )(fst)(maybe('No cycle found')(
            showCycle
        ))(
            compose(cycleFound)(snd)
        )([
            (
                'cycle([1, 2, 3])',
                take(10000)(cycle([1, 2, 3]))
            ), (
                '[0..10000] + cycle([1..8])',
                take(20000)(
                    chain(
                        enumFromTo(0)(10000),
                        cycle(enumFromTo(1)(8))
                    )
                )
            ), (
                '[1..10000]',
                enumFromTo(1)(10000)
            ), (
                'f(x) = (x*x + 1) modulo 255',
                take(10000)(iterate(
                    lambda x: (1 + (x * x)) % 255
                )(3))
            )
        ])
    )


# DISPLAY -------------------------------------------------

# showList :: [a] -> String
def showList(xs):
    ''''Compact stringification of a list,
        (no spaces after commas).
    '''
    return ''.join(repr(xs).split())


# showCycle :: ([a], Int, Int) -> String
def showCycle(cli):
    '''Stringification of cycleFound tuple.'''
    c, lng, iStart = cli
    return showList(c) + ' (from:' + str(iStart) + (
        ', length:' + str(lng) + ')'
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


# bind (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
def bind(m):
    '''bindMay provides the mechanism for composing a
       sequence of (a -> Maybe b) functions.
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


# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xxs):
    '''The concatenation of all the elements in a list.'''
    xs = list(chain.from_iterable(xxs))
    unit = '' if isinstance(xs, str) else []
    return unit if not xs else (
        ''.join(xs) if isinstance(xs[0], str) else xs
    )


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# findIndex :: (a -> Bool) -> [a] -> Maybe Int
def findIndex(p):
    '''Just the first index at which an
       element in xs matches p,
       or Nothing if no elements match.'''
    def go(xs):
        try:
            return Just(next(
                i for i, x in enumerate(xs) if p(x)
            ))
        except StopIteration:
            return Nothing()
    return lambda xs: go(xs)


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# fTable :: String -> (a -> String) ->
#                     (b -> String) ->
#        (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        ])
    return lambda xShow: lambda fxShow: (
        lambda f: lambda xs: go(
            xShow, fxShow, f, xs
        )
    )


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated
       applications of f to x.'''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return lambda x: go(x)


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).'''
    return lambda f: lambda m: v if m.get('Nothing') else (
        f(m.get('Just'))
    )


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else list(islice(xs, n))
    )


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    '''A function over a tuple
       derived from a default or
       curried function.'''
    return lambda xy: f(xy[0], xy[1])


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.'''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


# MAIN ---
if __name__ == '__main__':
    main()
