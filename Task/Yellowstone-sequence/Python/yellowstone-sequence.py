'''Yellowstone permutation OEIS A098550'''

from itertools import chain, count, islice
from operator import itemgetter
from math import gcd

from matplotlib import pyplot


# yellowstone :: [Int]
def yellowstone():
    '''A non-finite stream of terms from
       the Yellowstone permutation.
       OEIS A098550.
    '''
    # relativelyPrime :: Int -> Int -> Bool
    def relativelyPrime(a):
        return lambda b: 1 == gcd(a, b)

    # nextWindow :: (Int, Int, [Int]) -> (Int, Int, [Int])
    def nextWindow(triple):
        p2, p1, rest = triple
        [rp2, rp1] = map(relativelyPrime, [p2, p1])

        # match :: [Int] -> (Int, [Int])
        def match(xxs):
            x, xs = uncons(xxs)['Just']
            return (x, xs) if rp1(x) and not rp2(x) else (
                second(cons(x))(
                    match(xs)
                )
            )
        n, residue = match(rest)
        return (p1, n, residue)

    return chain(
        range(1, 3),
        map(
            itemgetter(1),
            iterate(nextWindow)(
                (2, 3, count(4))
            )
        )
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Terms of the Yellowstone permutation.'''

    print(showList(
        take(30)(yellowstone())
    ))
    pyplot.plot(
        take(100)(yellowstone())
    )
    pyplot.xlabel(main.__doc__)
    pyplot.show()


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


# cons :: a -> [a] -> [a]
def cons(x):
    '''Construction of a list from x as head,
       and xs as tail.
    '''
    return lambda xs: [x] + xs if (
        isinstance(xs, list)
    ) else x + xs if (
        isinstance(xs, str)
    ) else chain([x], xs)


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated
       applications of f to x.
    '''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return go


# second :: (a -> b) -> ((c, a) -> (c, b))
def second(f):
    '''A simple function lifted to a function over a tuple,
       with f applied only to the second of two values.
    '''
    return lambda xy: (xy[0], f(xy[1]))


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(repr(x) for x in xs) + ']'


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


# uncons :: [a] -> Maybe (a, [a])
def uncons(xs):
    '''The deconstruction of a non-empty list
       (or generator stream) into two parts:
       a head value, and the remaining values.
    '''
    if isinstance(xs, list):
        return Just((xs[0], xs[1:])) if xs else Nothing()
    else:
        nxt = take(1)(xs)
        return Just((nxt[0], xs)) if nxt else Nothing()


# MAIN ---
if __name__ == '__main__':
    main()
