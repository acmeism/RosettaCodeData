'''Approximate rationals from decimals'''

from math import (floor, gcd)
import sys


# approxRatio :: Float -> Float -> Ratio
def approxRatio(epsilon):
    '''The simplest rational approximation to
       n within the margin given by epsilon.
    '''
    def gcde(e, x, y):
        def _gcd(a, b):
            return a if b < e else _gcd(b, a % b)
        return _gcd(abs(x), abs(y))
    return lambda n: (lambda c=(
        gcde(epsilon if 0 < epsilon else (0.0001), 1, n)
    ): ratio(floor(n / c))(floor(1 / c)))()


# main :: IO ()
def main():
    '''Conversions at different levels of precision.'''

    xs = [0.9054054, 0.518518, 0.75]
    print(
        fTable(__doc__ + ' (epsilon of 1/10000):\n')(str)(
            lambda r: showRatio(r) + ' -> ' + repr(fromRatio(r))
        )(
            approxRatio(1 / 10000)
        )(xs)
    )
    print('\n')

    e = minBound(float)
    print(
        fTable(__doc__ + ' (epsilon of ' + repr(e) + '):\n')(str)(
            lambda r: showRatio(r) + ' -> ' + repr(fromRatio(r))
        )(
            approxRatio(e)
        )(xs)
    )


# GENERIC -------------------------------------------------

# fromRatio :: Ratio Int -> Float
def fromRatio(r):
    '''A floating point value derived from a
       a rational value.
    '''
    return r.get('numerator') / r.get('denominator')


# minBound :: Bounded Type -> a
def minBound(t):
    '''Minimum value for a bounded type.'''
    maxsize = sys.maxsize
    float_infomin = sys.float_info.min
    return {
        int: (-maxsize - 1),
        float: float_infomin,
        bool: False,
        str: chr(0)
    }[t]


# ratio :: Int -> Int -> Ratio Int
def ratio(n):
    '''Rational value constructed
       from a numerator and a denominator.
    '''
    def go(n, d):
        g = gcd(n, d)
        return {
            'type': 'Ratio',
            'numerator': n // g, 'denominator': d // g
        }
    return lambda d: go(n * signum(d), abs(d))


# showRatio :: Ratio -> String
def showRatio(r):
    '''String representation of the ratio r.'''
    d = r.get('denominator')
    return str(r.get('numerator')) + (
        ' / ' + str(d) if 1 != d else ''
    )


# signum :: Num -> Num
def signum(n):
    '''The sign of n.'''
    return -1 if 0 > n else (1 if 0 < n else 0)


# DISPLAY -------------------------------------------------

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
