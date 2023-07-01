'''mcNuggets list monad'''

from itertools import (chain, dropwhile)


# mcNuggetsByListMonad :: Int -> Set Int
def mcNuggetsByListMonad(limit):
    '''McNugget numbers up to limit.'''

    box = size(limit)
    return set(
        bind(
            box(6)
        )(lambda x: bind(
            box(9)
        )(lambda y: bind(
            box(20)
        )(lambda z: (
            lambda v=sum([x, y, z]): (
                [] if v > limit else [v]
            )
        )())))
    )


# Which, for comparison, is equivalent to:

# mcNuggetsByComprehension :: Int -> Set Int
def mcNuggetsByComprehension(limit):
    '''McNuggets numbers up to limit'''
    box = size(limit)
    return {
        v for v in (
            sum([x, y, z])
            for x in box(6)
            for y in box(9)
            for z in box(20)
        ) if v <= limit
    }


# size :: Int -> Int -> [Int]
def size(limit):
    '''Multiples of n up to limit.'''
    return lambda n: enumFromThenTo(0)(n)(limit)


# -------------------------- TEST --------------------------
def main():
    '''List monad and set comprehension - parallel routes'''

    def test(limit):
        def go(nuggets):
            ys = list(dropwhile(
                lambda x: x in nuggets,
                enumFromThenTo(limit)(limit - 1)(1)
            ))
            return str(ys[0]) if ys else (
                'No unreachable targets in this range.'
            )
        return lambda nuggets: go(nuggets)

    def fName(f):
        return f.__name__

    limit = 100
    print(
        fTable(main.__doc__ + ':\n')(fName)(test(limit))(
            lambda f: f(limit)
        )([mcNuggetsByListMonad, mcNuggetsByComprehension])
    )


# ------------------------ GENERIC -------------------------

# bind (>>=) :: [a] -> (a -> [b]) -> [b]
def bind(xs):
    '''List monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.
    '''
    return lambda f: chain.from_iterable(
        map(f, xs)
    )


# enumFromThenTo :: Int -> Int -> Int -> [Int]
def enumFromThenTo(m):
    '''Integer values enumerated from m to n
       with a step defined by nxt-m.
    '''
    def go(nxt, n):
        d = nxt - m
        return range(m, n - 1 if d < 0 else 1 + n, d)
    return lambda nxt: lambda n: go(nxt, n)


# ------------------------ DISPLAY -------------------------

# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
       f -> xs -> tabular string.
    '''
    def gox(xShow):
        def gofx(fxShow):
            def gof(f):
                def goxs(xs):
                    ys = [xShow(x) for x in xs]
                    w = max(map(len, ys))

                    def arrowed(x, y):
                        return y.rjust(w, ' ') + ' -> ' + fxShow(f(x))
                    return s + '\n' + '\n'.join(
                        map(arrowed, xs, ys)
                    )
                return goxs
            return gof
        return gofx
    return gox


# MAIN ---
if __name__ == '__main__':
    main()
