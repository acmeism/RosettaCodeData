'''Fusc sequence'''

from itertools import chain, count, islice
from operator import itemgetter


# As an infinite stream of terms,

# infiniteFusc :: [Int]
def infiniteFusc():
    '''Fusc sequence.
       OEIS A2487
    '''
    def go(step):
        isEven, n, xxs = step
        x, xs = xxs[0], xxs[1:]
        if isEven:
            nxt = n + x
            return not isEven, nxt, xxs + [nxt]
        else:
            return not isEven, x, xs + [x]

    return chain(
        [0, 1],
        map(
            itemgetter(1),
            iterate(go)(
                (True, 1, [1])
            )
        )
    )


# Or as a function over an integer:

# fusc :: Int -> Int
def fusc(i):
    '''Fusc sequence'''
    def go(n):
        if 0 == n:
            return (1, 0)
        else:
            x, y = go(n // 2)
            return (x + y, y) if 0 == n % 2 else (
                x, x + y
            )
    return 0 if 1 > i else (
        go(i - 1)[0]
    )


# firstFuscOfEachMagnitude ::
def firstFuscOfEachMagnitude():
    '''Non-finite stream of each term
       in OEIS A2487 that requires an
       unprecedented quantity of decimal digits.
    '''
    a2487 = enumerate(map(fusc, count()))

    def go(e):
        limit = 10 ** e
        return next(
            (i, x) for i, x in a2487
            if limit <= x
        )
    return (
        chain([(0, 0)], map(go, count(1)))
    )


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Tests'''

    print('First 61 terms:')
    print(showList(
        take(61)(
            map(fusc, count())
        )
    ))

    print('\nFirst term of each decimal magnitude:')
    print('(Index, Term):')
    ixs = firstFuscOfEachMagnitude()
    for _ in range(0, 5):
        print(next(ixs))


# -------------------------GENERIC-------------------------

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
    return lambda x: go(x)


# showList :: [a] -> String
def showList(xs):
    '''Compact stringification of a list.'''
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


# MAIN ---
if __name__ == '__main__':
    main()
