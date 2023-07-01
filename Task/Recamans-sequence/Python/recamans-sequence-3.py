'''Recaman by iteration of a function over a tuple.'''

from itertools import (islice)


# recamanTupleSucc :: Set Int -> (Int, Int, Bool) -> (Int, Int, Bool)
def recamanTupleSucc(seen):
    '''The Nth in a series of Recaman tuples,
       (N, previous term, boolPreviouslySeen?)
       given the set of all terms seen so far.'''
    def go(n, r, _):
        back = r - n
        nxt = n + r if 0 > back or (back in seen) else back
        bln = nxt in seen
        seen.add(nxt)
        return (1 + n, nxt, bln)
    return lambda tpl: go(*tpl)


# ------------------------- TEST -------------------------
# main :: IO()
def main():
    '''First 15, and first duplicated Recaman.'''
    f = recamanTupleSucc(set([0]))
    print(
        'First 15 Recaman:\n',
        list(map(
            snd,
            take(15)(iterate(f)((1, 0, False)))
        ))
    )
    f = recamanTupleSucc(set([0]))
    print(
        'First duplicated Recaman:\n',
        until(lambda x: x[2])(f)(
            (1, 0, False)
        )[1]
    )

    sk = set(enumFromTo(0)(1000))
    sr = set([0])
    f = recamanTupleSucc(sr)
    print(
        'Number of Recaman terms needed to generate',
        'all integers from [0..1000]:\n',
        until(
            lambda x: not x[2] and 1001 > x[1] and sk.issubset(sr)
        )(f)(
            (1, 0, False)
        )[0] - 1
    )


# ----------------- GENERIC ABSTRACTIONS -----------------

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
       or xs itself if n > length xs.'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else islice(xs, n)
    )


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


# MAIN ---
if __name__ == '__main__':
    main()
