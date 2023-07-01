'''Knuth shuffle as a fold'''

from functools import reduce
from random import randint


# knuthShuffle :: [a] -> IO [a]
def knuthShuffle(xs):
    '''A pseudo-random shuffle of the elements in xs.'''
    return reduce(
        swapped,
        enumerate(randoms(len(xs))), xs
    )


# swapped :: (Int, Int) -> [a] -> [a]
def swapped(xs, ij):
    '''New list in which the elements at indices
       i and j of xs are swapped.
    '''
    def go(a, b):
        if a != b:
            m, n = (a, b) if b > a else (b, a)
            l, ht = splitAt(m)(xs)
            ys, zs = splitAt((n - m) - 1)(ht[1:])
            return l + [zs[0]] + ys + [ht[0]] + zs[1:]
        else:
            return xs
    i, j = ij
    z = len(xs) - 1
    return xs if i > z or j > z else go(i, j)


# randoms :: Int -> IO [Int]
def randoms(n):
    '''Pseudo-random list of n - 1 indices.
    '''
    return list(map(randomRInt(0)(n - 1), range(1, n)))


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Repeated Knuth shuffles of ['a' .. 'k']'''

    print(
        fTable(main.__doc__ + ':\n')(str)(lambda x: ''.join(x))(
            lambda _: knuthShuffle(list('abcdefghijk'))
        )(range(1, 11))
    )


# GENERIC -------------------------------------------------

# randomRInt :: Int -> Int -> IO () -> Int
def randomRInt(m):
    '''The return value of randomRInt is itself
       a function. The returned function, whenever
       called, yields a a new pseudo-random integer
       in the range [m..n].
    '''
    return lambda n: lambda _: randint(m, n)


# splitAt :: Int -> [a] -> ([a], [a])
def splitAt(n):
    '''A tuple pairing the prefix of length n
       with the rest of xs.
    '''
    return lambda xs: (xs[0:n], xs[n:])


# FORMATTING -----------------------------------------------------------

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
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# MAIN ---
if __name__ == '__main__':
    main()
