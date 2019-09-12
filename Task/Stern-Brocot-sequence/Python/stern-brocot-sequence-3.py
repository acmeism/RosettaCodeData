'''Stern-Brocot sequence'''

from itertools import (count, dropwhile, islice, takewhile)
import operator
import math


# sternBrocot :: Generator [Int]
def sternBrocot():
    '''Non-finite list of the Stern-Brocot
       sequence of integers.'''

    def go(xs):
        x = xs[1]
        return (tail(xs) + [x + head(xs), x])
    return fmapGen(head)(
        iterate(go)([1, 1])
    )


# TESTS ---------------------------------------------------

# main :: IO ()
def main():
    '''Various tests'''

    [eq, ne, gcd] = map(
        curry,
        [operator.eq, operator.ne, math.gcd]
    )

    sbs = take(1200)(sternBrocot())
    ixSB = zip(sbs, enumFrom(1))

    print(unlines(map(str, [

        # First 15 members of the sequence.
        take(15)(sbs),

        # Indices of where the numbers [1..10] first appear.
        take(10)(
            nubBy(on(eq)(fst))(
                sorted(
                    takewhile(
                        compose(ne(12))(fst),
                        ixSB
                    ),
                    key=fst
                )
            )
        ),

        #  Index of where the number 100 first appears.
        take(1)(dropwhile(compose(ne(100))(fst), ixSB)),

        # Is the gcd of any two consecutive members,
        # up to the 1000th member, always one ?
        every(compose(eq(1)(gcd)))(
            take(1000)(zip(sbs, tail(sbs)))
        )
    ])))


# GENERIC ABSTRACTIONS ------------------------------------


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    return lambda a: lambda b: f(a, b)


# enumFrom :: Enum a => a -> [a]
def enumFrom(x):
    '''A non-finite stream of enumerable values,
       starting from the given value.'''
    return count(x) if isinstance(x, int) else (
        map(chr, count(ord(x)))
    )


# every :: (a -> Bool) -> [a] -> Bool
def every(p):
    '''True if p(x) holds for every x in xs'''
    return lambda xs: all(map(p, xs))


# fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
def fmapGen(f):
    '''A function f mapped over a
       non finite stream of values.'''
    def go(g):
        while True:
            v = next(g, None)
            if None is not v:
                yield f(v)
            else:
                return
    return lambda gen: go(gen)


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# head :: [a] -> a
def head(xs):
    '''The first element of a non-empty list.'''
    return xs[0]


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


# nubBy :: (a -> a -> Bool) -> [a] -> [a]
def nubBy(p):
    '''A sublist of xs from which all duplicates,
       (as defined by the equality predicate p)
       are excluded.'''
    def go(xs):
        if not xs:
            return []
        x = xs[0]
        return [x] + go(
            list(filter(
                lambda y: not p(x)(y),
                xs[1:]
            ))
        )
    return lambda xs: go(xs)


# on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
def on(f):
    '''A function returning the value of applying
      the binary f to g(a) g(b)'''
    return lambda g: lambda a: lambda b: f(g(a))(g(b))


# tail :: [a] -> [a]
# tail :: Gen [a] -> [a]
def tail(xs):
    '''The elements following the head of a
       (non-empty) list or generator stream.'''
    if isinstance(xs, list):
        return xs[1:]
    else:
        list(islice(xs, 1))  # First item dropped.
        return xs


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


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
