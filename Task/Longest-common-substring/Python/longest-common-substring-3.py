'''Longest common substring'''

from itertools import accumulate, chain
from functools import reduce


# longestCommon :: String -> String -> String
def longestCommon(s1):
    '''The longest common substring of
       two given strings.
    '''
    def go(s2):
        return max(intersect(
            *map(lambda s: map(
                concat,
                concatMap(tails)(
                    compose(tail, list, inits)(s)
                )
            ), [s1, s2])
        ), key=len)
    return go


# ------------------------- TEST -------------------------
def main():
    '''Test'''
    print(
        longestCommon(
            "testing123testing"
        )(
            "thisisatest"
        )
    )


# ----------------------- GENERIC ------------------------

# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    def go(f, g):
        def fg(x):
            return f(g(x))
        return fg
    return reduce(go, fs, lambda x: x)


# concat :: [String] -> String
def concat(xs):
    '''The concatenation of all the elements
       in a list or iterable.
    '''
    return ''.join(xs)


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been
       mapped.
       The list monad can be derived by using a function f
       which wraps its output in a list, (using an empty
       list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


# inits :: [a] -> [[a]]
def inits(xs):
    '''all initial segments of xs, shortest first.'''
    return accumulate(chain([[]], xs), lambda a, x: a + [x])


# intersect :: [a] -> [a] -> [a]
def intersect(xs, ys):
    '''The ordered intersection of xs and ys.
       intersect([1,2,2,3,4])([6,4,4,2]) -> [2,2,4]
    '''
    s = set(ys)
    return (x for x in xs if x in s)


# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but defines a succession of
       intermediate values, building from the left.
    '''
    def go(a):
        def g(xs):
            return accumulate(chain([a], xs), f)
        return g
    return go


# tail :: [a] -> [a]
# tail :: Gen [a] -> [a]
def tail(xs):
    '''The elements following the head of a
       (non-empty) list.
    '''
    return xs[1:]


# tails :: [a] -> [[a]]
def tails(xs):
    '''All final segments of xs,
       longest first.
    '''
    return [
        xs[i:] for i in
        range(0, 1 + len(xs))
    ]


# MAIN ---
main()
