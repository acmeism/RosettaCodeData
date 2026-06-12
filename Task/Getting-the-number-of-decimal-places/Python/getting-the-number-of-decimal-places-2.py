'''Report the decimal counts in default stringifications.'''

import math


# decimalCount :: Num -> Either String (Int, Int)
def decimalCount(n):
    '''Either a message string, or a tuple
       giving the number of decimals in the default
       (repr) representations of the real
       (and any imaginary part) of the given number.
    '''
    # decimalLen :: Float -> Int
    def decimalLen(f):
        return len(repr(f).split('.')[-1])

    return Right(
        (0, 0) if isinstance(n, int) else (
            (decimalLen(n), 0)
        ) if isinstance(n, float) else (
            tuple(decimalLen(x) for x in [n.real, n.imag])
        )
    ) if isinstance(n, (float, complex, int)) else (
        Left(repr(n) + ' is not a float, complex or int')
    )


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Counts of decimals in default stringifications of
       real (and any imaginary) components of various
       Python numeric values.
    '''
    print(fTable(
        'Decimal counts in stringifications of real and imaginary components:'
    )(repr)(
        either(identity)(repr)
    )(decimalCount)([
        7, 1.25, 1.23456e2,
        1 / 7,
        2 ** 0.5,
        math.pi, math.e,
        complex(1.23, 4.567),
        None
    ]))


# ------------------------ GENERIC -------------------------

# Left :: a -> Either a b
def Left(x):
    '''Constructor for an empty Either (option type) value
       with an associated string.
    '''
    return {'type': 'Either', 'Right': None, 'Left': x}


# Right :: b -> Either a b
def Right(x):
    '''Constructor for a populated Either (option type) value'''
    return {'type': 'Either', 'Left': None, 'Right': x}


# either :: (a -> c) -> (b -> c) -> Either a b -> c
def either(fl):
    '''The application of fl to e if e is a Left value,
       or the application of fr to e if e is a Right value.
    '''
    return lambda fr: lambda e: fl(e['Left']) if (
        None is e['Right']
    ) else fr(e['Right'])


# identity :: a -> a
def identity(x):
    '''The identity function.'''
    return x


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
