'''Van Eck series by map-accumulation'''

from functools import reduce
from itertools import repeat


# vanEck :: Int -> [Int]
def vanEck(n):
    '''First n terms of the vanEck sequence.'''
    def go(xns, i):
        x, ns = xns

        prev = ns[x]
        v = i - prev if 0 is not prev else 0
        return (
            (v, insert(ns, x, i)),
            v
        )

    return [0] + mapAccumL(go)((0, list(repeat(0, n))))(
        range(1, n)
    )[1]


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''The last 10 of the first N vanEck terms'''
    print(
        fTable(main.__doc__ + ':\n')(
            lambda m: 'N=' + str(m), repr,
            lambda n: vanEck(n)[-10:], [10, 1000, 10000]
        )
    )


# ----------------------- FORMATTING -----------------------
# fTable :: String -> (a -> String) ->
#                     (b -> String) -> (a -> b) -> [a] -> String
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
    return go


# ------------------------ GENERIC -------------------------

# insert :: Array Int -> Int -> Int -> Array Int
def insert(xs, i, v):
    '''An array updated at position i with value v.'''
    xs[i] = v
    return xs


# mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
def mapAccumL(f):
    '''A tuple of an accumulation and a list derived by a
       combined map and fold,
       with accumulation from left to right.
    '''
    def go(a, x):
        tpl = f(a[0], x)
        return (tpl[0], a[1] + [tpl[1]])
    return lambda acc: lambda xs: (
        reduce(go, xs, (acc, []))
    )


# MAIN ---
if __name__ == '__main__':
    main()
