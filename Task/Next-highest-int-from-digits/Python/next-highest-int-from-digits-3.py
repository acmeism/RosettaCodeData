'''Next highest int from digits'''

from itertools import chain, islice, permutations, tee


# --------------- LAZY STREAM OF SUCCESSORS ----------------

# digitShuffleSuccessors :: Int -> [Int]
def digitShuffleSuccessors(n):
    '''Iterator stream of all digit-shuffle
       successors of n, where 0 <= n.
    '''
    def go(ds):
        delta = int(''.join(ds)) - n
        return [] if 0 >= delta else [delta]
    return map(
        add(n),
        sorted(
            set(concatMap(go)(
                permutations(str(n))
            ))
        )
    )


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Taking up to 5 digit-shuffle successors for each:'''

    def showSuccs(n):
        def go(xs):
            ys, zs = tee(xs)
            harvest = take(n)(ys)
            return (
                repr(len(harvest)) + ' of ' + (
                    repr(len(list(zs))) + ':  '
                )
            ).rjust(12, ' ') + repr(harvest)
        return go

    print(
        fTable(main.__doc__ + '\n')(str)(showSuccs(5))(
            digitShuffleSuccessors
        )([
            0,
            9,
            12,
            21,
            12453,
            738440,
            45072010,
            95322020
        ])
    )


# ------------------------ GENERIC -------------------------

# add (+) :: Num a => a -> a -> a
def add(a):
    '''Curried addition.'''
    def go(b):
        return a + b
    return go


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''The concatenation of a mapping.
       The list monad can be derived by using a function f
       which wraps its output in a list, using an empty
       list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function ->
       fx display function -> f -> xs -> tabular string.
    '''
    def gox(xShow):
        def gofx(fxShow):
            def gof(f):
                def goxs(xs):
                    ys = [xShow(x) for x in xs]
                    w = max(map(len, ys))

                    def arrowed(x, y):
                        return y.rjust(w, ' ') + (
                            ' -> ' + fxShow(f(x))
                        )
                    return s + '\n' + '\n'.join(
                        map(arrowed, xs, ys)
                    )
                return goxs
            return gof
        return gofx
    return gox


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


# MAIN ---
if __name__ == '__main__':
    main()
