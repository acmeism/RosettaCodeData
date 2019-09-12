'''Quick select'''

from functools import reduce


# quickselect :: Ord a => Int -> [a] -> a
def quickSelect(k):
    '''The kth smallest element
       in the unordered list xs.'''
    def go(k, xs):
        x = xs[0]

        def ltx(y):
            return y < x
        ys, zs = partition(ltx)(xs[1:])
        n = len(ys)
        return go(k, ys) if k < n else (
            go(k - n - 1, zs) if k > n else x
        )
    return lambda xs: go(k, xs) if xs else None


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''

    v = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
    print(list(map(
        flip(quickSelect)(v),
        range(0, len(v))
    )))


# GENERIC -------------------------------------------------


# flip :: (a -> b -> c) -> b -> a -> c
def flip(f):
    '''The (curried) function f with its
       arguments reversed.'''
    return lambda a: lambda b: f(b)(a)


# partition :: (a -> Bool) -> [a] -> ([a], [a])
def partition(p):
    '''The pair of lists of those elements in xs
       which respectively do, and don't
       satisfy the predicate p.'''
    def go(a, x):
        ts, fs = a
        return (ts + [x], fs) if p(x) else (ts, fs + [x])
    return lambda xs: reduce(go, xs, ([], []))


# MAIN ---
if __name__ == '__main__':
    main()
