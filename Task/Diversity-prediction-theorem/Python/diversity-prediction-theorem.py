'''Diversity prediction theorem'''

from itertools import chain
from functools import reduce


#  diversityValues :: Num a => a -> [a] ->
#  { mean-Error :: a, crowd-error :: a, diversity :: a }
def diversityValues(x):
    '''The mean error, crowd error and
       diversity, for a given observation x
       and a non-empty list of predictions ps.
    '''
    def go(ps):
        mp = mean(ps)
        return {
            'mean-error': meanErrorSquared(x)(ps),
            'crowd-error': pow(x - mp, 2),
            'diversity': meanErrorSquared(mp)(ps)
        }
    return go


# meanErrorSquared :: Num -> [Num] -> Num
def meanErrorSquared(x):
    '''The mean of the squared differences
       between the observed value x and
       a non-empty list of predictions ps.
    '''
    def go(ps):
        return mean([
            pow(p - x, 2) for p in ps
        ])
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Observed value: 49,
       prediction lists: various.
    '''

    print(unlines(map(
        showDiversityValues(49),
        [
            [48, 47, 51],
            [48, 47, 51, 42],
            [50, '?', 50, {}, 50],  # Non-numeric values.
            []                      # Missing predictions.
        ]
    )))
    print(unlines(map(
        showDiversityValues('49'),  # String in place of number.
        [
            [50, 50, 50],
            [40, 35, 40],
        ]
    )))


# ---------------------- FORMATTING ----------------------

# showDiversityValues :: Num -> [Num] -> Either String String
def showDiversityValues(x):
    '''Formatted string representation
       of diversity values for a given
       observation x and a non-empty
       list of predictions p.
    '''
    def go(ps):
        def showDict(dct):
            w = 4 + max(map(len, dct.keys()))

            def showKV(a, kv):
                k, v = kv
                return a + k.rjust(w, ' ') + (
                    ' : ' + showPrecision(3)(v) + '\n'
                )
            return 'Predictions: ' + showList(ps) + ' ->\n' + (
                reduce(showKV, dct.items(), '')
            )

        def showProblem(e):
            return (
                unlines(map(indented(1), e)) if (
                    isinstance(e, list)
                ) else indented(1)(repr(e))
            ) + '\n'

        return 'Observation:  ' + repr(x) + '\n' + (
            either(showProblem)(showDict)(
                bindLR(numLR(x))(
                    lambda n: bindLR(numsLR(ps))(
                        compose(Right, diversityValues(n))
                    )
                )
            )
        )
    return go


# ------------------ GENERIC FUNCTIONS -------------------

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


# bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
def bindLR(m):
    '''Either monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.
    '''
    def go(mf):
        return (
            mf(m.get('Right')) if None is m.get('Left') else m
        )
    return go


# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    def go(f, g):
        def fg(x):
            return f(g(x))
        return fg
    return reduce(go, fs, identity)


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


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


# indented :: Int -> String -> String
def indented(n):
    '''String indented by n multiples
       of four spaces.
    '''
    return lambda s: (4 * ' ' * n) + s

# mean :: [Num] -> Float
def mean(xs):
    '''Arithmetic mean of a list
       of numeric values.
    '''
    return sum(xs) / float(len(xs))


# numLR :: a -> Either String Num
def numLR(x):
    '''Either Right x if x is a float or int,
       or a Left explanatory message.'''
    return Right(x) if (
        isinstance(x, (float, int))
    ) else Left(
        'Expected number, saw: ' + (
            str(type(x)) + ' ' + repr(x)
        )
    )


# numsLR :: [a] -> Either String [Num]
def numsLR(xs):
    '''Either Right xs if all xs are float or int,
       or a Left explanatory message.'''
    def go(ns):
        ls, rs = partitionEithers(map(numLR, ns))
        return Left(ls) if ls else Right(rs)
    return bindLR(
        Right(xs) if (
            bool(xs) and isinstance(xs, list)
        ) else Left(
            'Expected a non-empty list, saw: ' + (
                str(type(xs)) + ' ' + repr(xs)
            )
        )
    )(go)


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


# showList :: [a] -> String
def showList(xs):
    '''Compact string representation of a list'''
    return '[' + ','.join(str(x) for x in xs) + ']'


# showPrecision :: Int -> Float -> String
def showPrecision(n):
    '''A string showing a floating point number
       at a given degree of precision.'''
    def go(x):
        return str(round(x, n))
    return go


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
