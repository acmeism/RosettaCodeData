'''Levenshtein distance'''

from itertools import (accumulate, chain, islice)
from functools import reduce


# levenshtein :: String -> String -> Int
def levenshtein(sa):
    '''Levenshtein distance between
       two strings.'''
    s1 = list(sa)

    # go :: [Int] -> Char -> [Int]
    def go(ns, c):
        n, ns1 = ns[0], ns[1:]

        # gap :: Int -> (Char, Int, Int) -> Int
        def gap(z, c1xy):
            c1, x, y = c1xy
            return min(
                succ(y),
                succ(z),
                succ(x) if c != c1 else x
            )
        return scanl(gap)(succ(n))(
            zip(s1, ns, ns1)
        )
    return lambda sb: reduce(
        go, list(sb), enumFromTo(0)(len(s1))
    )[-1]


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tests'''

    pairs = [
        ('rosettacode', 'raisethysword'),
        ('kitten', 'sitting'),
        ('saturday', 'sunday')
    ]

    print(
        tabulated(
            'Levenshtein minimum edit distances:\n'
        )(str)(str)(
            uncurry(levenshtein)
        )(concat(map(
            list,
            zip(pairs, map(swap, pairs))
        )))
    )


# GENERIC -------------------------------------------------

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


# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but returns a succession of
       intermediate values, building from the left.'''
    return lambda a: lambda xs: (
        list(accumulate(chain([a], xs), f))
    )


# swap :: (a, b) -> (b, a)
def swap(tpl):
    '''The swapped components of a pair.'''
    return (tpl[1], tpl[0])


# succ :: Int => Int -> Int
def succ(x):
    '''The successor of a value.
       For numeric types, (1 +).'''
    return 1 + x


# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function ->
                 fx display function ->
                 f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x))
            for x in xs

        ])
    return lambda xShow: lambda fxShow: (
        lambda f: lambda xs: go(
            xShow, fxShow, f, xs
        )
    )


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
       derived from a curried function.'''
    return lambda xy: f(xy[0])(
        xy[1]
    )


# MAIN ---
if __name__ == '__main__':
    main()
