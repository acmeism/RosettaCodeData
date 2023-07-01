'''Egyptian fractions'''

from fractions import Fraction
from functools import reduce
from operator import neg


# eqyptianFraction :: Ratio Int -> Ratio Int
def eqyptianFraction(nd):
    '''The rational number nd as a sum
       of the series of unit fractions
       obtained by application of the
       greedy algorithm.'''
    def go(x):
        n, d = x.numerator, x.denominator
        r = 1 + d // n if n else None
        return Just((0, x) if 1 == n else (
            (fr(n % d, d), fr(n // d, 1)) if n > d else (
                fr(-d % n, d * r), fr(1, r)
            )
        )) if n else Nothing()
    fr = Fraction
    f = unfoldr(go)
    return list(map(neg, f(-nd))) if 0 > nd else f(nd)


# TESTS ---------------------------------------------------

# maxEqyptianFraction :: Int -> (Ratio Int -> a)
#                               -> (Ratio Int, a)
def maxEqyptianFraction(nDigits):
    '''An Egyptian Fraction, representing a
       proper fraction with numerators and
       denominators of up to n digits each,
       which returns a maximal value for the
       supplied function f.'''

    # maxVals :: ([Ratio Int], a) -> (Ratio Int, a)
    #                               -> ([Ratio Int], a)
    def maxima(xsv, ndfx):
        xs, v = xsv
        nd, fx = ndfx
        return ([nd], fx) if fx > v else (
            xs + [nd], v
        ) if fx == v and nd not in xs else xsv

    # go :: (Ratio Int -> a) -> ([Ratio Int], a)
    def go(f):
        iLast = int(nDigits * '9')
        fs, mx = reduce(
            maxima, [
                (nd, f(eqyptianFraction(nd))) for nd in [
                    Fraction(n, d)
                    for n in enumFromTo(1)(iLast)
                    for d in enumFromTo(1 + n)(iLast)
                ]
            ],
            ([], 0)
        )
        return f.__name__ + ' -> [' + ', '.join(
            map(str, fs)
        ) + '] -> ' + str(mx)
    return lambda f: go(f)


# main :: IO ()
def main():
    '''Tests'''

    ef = eqyptianFraction
    fr = Fraction

    print('Three values as Eqyptian fractions:')
    print('\n'.join([
        str(fr(*nd)) + ' -> ' + ' + '.join(map(str, ef(fr(*nd))))
        for nd in [(43, 48), (5, 121), (2014, 59)]
    ]))

    # maxDenominator :: [Ratio Int] -> Int
    def maxDenominator(ef):
        return max(map(lambda nd: nd.denominator, ef))

    # maxTermCount :: [Ratio Int] -> Int
    def maxTermCount(ef):
        return len(ef)

    for i in [1, 2, 3]:
        print(
            '\nMaxima for proper fractions with up to ' + (
                str(i) + ' digit(s):'
            )
        )
        for f in [maxTermCount, maxDenominator]:
            print(maxEqyptianFraction(i)(f))


# GENERIC -------------------------------------------------


# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# unfoldr :: (b -> Maybe (b, a)) -> b -> [a]
def unfoldr(f):
    '''Dual to reduce or foldr.
       Where catamorphism reduces a list to a summary value,
       the anamorphic unfoldr builds a list from a seed value.
       As long as f returns Just(a, b), a is prepended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns Nothing, the completed list is returned.'''
    def go(xr):
        mb = f(xr[0])
        if mb.get('Nothing'):
            return []
        else:
            y, r = mb.get('Just')
            return [r] + go((y, r))

    return lambda x: go((x, x))


# MAIN ---
if __name__ == '__main__':
    main()
