'''The intersection of two lines.'''

from itertools import product


# intersection :: Line -> Line -> Either String Point
def intersection(ab):
    '''Either the point at which the lines ab and pq
       intersect, or a message string indicating that
       they are parallel and have no intersection.'''
    def delta(f):
        return lambda x: f(fst(x)) - f(snd(x))

    def prodDiff(abcd):
        [a, b, c, d] = abcd
        return (a * d) - (b * c)

    def go(pq):
        [abDX, pqDX, abDY, pqDY] = apList(
            [delta(fst), delta(snd)]
        )([ab, pq])
        determinant = prodDiff([abDX, abDY, pqDX, pqDY])

        def point():
            [abD, pqD] = map(
                lambda xy: prodDiff(
                    apList([fst, snd])([fst(xy), snd(xy)])
                ), [ab, pq]
            )
            return apList(
                [lambda abpq: prodDiff(
                    [abD, fst(abpq), pqD, snd(abpq)]) / determinant]
            )(
                [(abDX, pqDX), (abDY, pqDY)]
            )
        return Right(point()) if 0 != determinant else Left(
            '( Parallel lines - no intersection )'
        )

    return lambda pq: bindLR(go(pq))(
        lambda xs: Right((fst(xs), snd(xs)))
    )


# --------------------------TEST---------------------------
# main :: IO()
def main():
    '''Test'''

    # Left(message - no intersection) or Right(point)
    # lrPoint :: Either String Point
    lrPoint = intersection(
        ((4.0, 0.0), (6.0, 10.0))
    )(
        ((0.0, 3.0), (10.0, 7.0))
    )
    print(
        lrPoint['Left'] or lrPoint['Right']
    )


# --------------------GENERIC FUNCTIONS--------------------

# Left :: a -> Either a b
def Left(x):
    '''Constructor for an empty Either (option type) value
       with an associated string.'''
    return {'type': 'Either', 'Right': None, 'Left': x}


# Right :: b -> Either a b
def Right(x):
    '''Constructor for a populated Either (option type) value'''
    return {'type': 'Either', 'Left': None, 'Right': x}


# apList (<*>) :: [(a -> b)] -> [a] -> [b]
def apList(fs):
    '''The application of each of a list of functions,
       to each of a list of values.
    '''
    def go(fx):
        f, x = fx
        return f(x)
    return lambda xs: [
        go(x) for x
        in product(fs, xs)
    ]


# bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
def bindLR(m):
    '''Either monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.'''
    return lambda mf: (
        mf(m.get('Right')) if None is m.get('Left') else m
    )


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# MAIN ---
if __name__ == '__main__':
    main()
