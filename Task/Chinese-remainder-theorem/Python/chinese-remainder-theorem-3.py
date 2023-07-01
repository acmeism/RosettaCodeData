'''Chinese remainder theorem'''

from operator import (add, mul)
from functools import reduce


# cnRemainder :: [Int] -> [Int] -> Either String Int
def cnRemainder(ms):
    '''Chinese remainder theorem.
       (moduli, residues) -> Either explanation or solution
    '''
    def go(ms, rs):
        mp = numericProduct(ms)
        cms = [(mp // x) for x in ms]

        def possibleSoln(invs):
            return Right(
                sum(map(
                    mul,
                    cms, map(mul, rs, invs)
                )) % mp
            )
        return bindLR(
            zipWithEither(modMultInv)(cms)(ms)
        )(possibleSoln)

    return lambda rs: go(ms, rs)


# modMultInv :: Int -> Int -> Either String Int
def modMultInv(a, b):
    '''Modular multiplicative inverse.'''
    x, y = eGcd(a, b)
    return Right(x) if 1 == (a * x + b * y) else (
        Left('no modular inverse for ' + str(a) + ' and ' + str(b))
    )


# egcd :: Int -> Int -> (Int, Int)
def eGcd(a, b):
    '''Extended greatest common divisor.'''
    def go(a, b):
        if 0 == b:
            return (1, 0)
        else:
            q, r = divmod(a, b)
            (s, t) = go(b, r)
            return (t, s - q * t)
    return go(a, b)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tests of soluble and insoluble cases.'''

    print(
        fTable(
            __doc__ + ':\n\n         (moduli, residues) -> ' + (
                'Either solution or explanation\n'
            )
        )(repr)(
            either(compose(quoted("'"))(curry(add)('No solution: ')))(
                compose(quoted(' '))(repr)
            )
        )(uncurry(cnRemainder))([
            ([10, 4, 12], [11, 12, 13]),
            ([11, 12, 13], [10, 4, 12]),
            ([10, 4, 9], [11, 22, 19]),
            ([3, 5, 7], [2, 3, 2]),
            ([2, 3, 2], [3, 5, 7])
        ])
    )


# GENERIC -------------------------------------------------

# Left :: a -> Either a b
def Left(x):
    '''Constructor for an empty Either (option type) value
       with an associated string.'''
    return {'type': 'Either', 'Right': None, 'Left': x}


# Right :: b -> Either a b
def Right(x):
    '''Constructor for a populated Either (option type) value'''
    return {'type': 'Either', 'Left': None, 'Right': x}
# any :: (a -> Bool) -> [a] -> Bool


def any_(p):
    '''True if p(x) holds for at least
       one item in xs.'''
    def go(xs):
        for x in xs:
            if p(x):
                return True
        return False
    return lambda xs: go(xs)


# bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
def bindLR(m):
    '''Either monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.'''
    return lambda mf: (
        mf(m.get('Right')) if None is m.get('Left') else m
    )


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    return lambda a: lambda b: f(a, b)


# either :: (a -> c) -> (b -> c) -> Either a b -> c
def either(fl):
    '''The application of fl to e if e is a Left value,
       or the application of fr to e if e is a Right value.'''
    return lambda fr: lambda e: fl(e['Left']) if (
        None is e['Right']
    ) else fr(e['Right'])


# fTable :: String -> (a -> String) ->
#                     (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function ->
                 fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + (' -> ') + fxShow(f(x))
            for x in xs
        ])
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# numericProduct :: [Num] -> Num
def numericProduct(xs):
    '''The arithmetic product of all numbers in xs.'''
    return reduce(mul, xs, 1)


# partitionEithers :: [Either a b] -> ([a],[b])
def partitionEithers(lrs):
    '''A list of Either values partitioned into a tuple
       of two lists, with all Left elements extracted
       into the first list, and Right elements
       extracted into the second list.
    '''
    def go(a, x):
        ls, rs = a
        r = x.get('Right')
        return (ls + [x.get('Left')], rs) if None is r else (
            ls, rs + [r]
        )
    return reduce(go, lrs, ([], []))


# quoted :: Char -> String -> String
def quoted(c):
    '''A string flanked on both sides
       by a specified quote character.
    '''
    return lambda s: c + s + c


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    '''A function over a tuple,
       derived from a curried function.'''
    return lambda xy: f(xy[0])(xy[1])


# zipWithEither :: (a -> b -> Either String  c)
#            -> [a] -> [b] -> Either String [c]
def zipWithEither(f):
    '''Either a list of results if f succeeds with every pair
       in the zip of xs and ys, or an explanatory string
       if any application of f returns no result.
    '''
    def go(xs, ys):
        ls, rs = partitionEithers(map(f, xs, ys))
        return Left(ls[0]) if ls else Right(rs)
    return lambda xs: lambda ys: go(xs, ys)


# MAIN ---
if __name__ == '__main__':
    main()
