'''Hailstone sequences'''

from itertools import (islice, takewhile)


# hailstone :: Int -> [Int]
def hailstone(x):
    '''Hailstone sequence starting with x.'''
    def p(n):
        return 1 != n
    return list(takewhile(p, iterate(collatz)(x))) + [1]


# collatz :: Int -> Int
def collatz(n):
    '''Next integer in the hailstone sequence.'''
    return 3 * n + 1 if 1 & n else n // 2


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Tests.'''

    n = 27
    xs = hailstone(n)
    print(unlines([
        f'The hailstone sequence for {n} has {len(xs)} elements,',
        f'starting with {take(4)(xs)},',
        f'and ending with {drop(len(xs) - 4)(xs)}.\n'
    ]))

    (a, b) = (1, 99999)
    (i, x) = max(
        enumerate(
            map(compose(len)(hailstone), enumFromTo(a)(b))
        ),
        key=snd
    )
    print(unlines([
        f'The number in the range {a}..{b} '
        f'which produces the longest sequence is {1 + i},',
        f'generating a hailstone sequence of {x} integers.'
    ]))


# ----------------------- GENERIC ------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Function composition.'''
    return lambda f: lambda x: g(f(x))


# drop :: Int -> [a] -> [a]
# drop :: Int -> String -> String
def drop(n):
    '''The sublist of xs beginning at
       (zero-based) index n.
    '''
    def go(xs):
        if isinstance(xs, (list, tuple, str)):
            return xs[n:]
        else:
            take(n)(xs)
            return xs
    return go


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: range(m, 1 + n)


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


# snd :: (a, b) -> b
def snd(tpl):
    '''Second component of a tuple.'''
    return tpl[1]


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


# unlines :: [String] -> String
def unlines(xs):
    '''A single newline-delimited string derived
       from a list of strings.'''
    return '\n'.join(xs)


if __name__ == '__main__':
    main()
