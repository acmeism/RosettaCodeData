'''Sparkline in Unicode'''

from functools import reduce
import operator
import re


# ------------------- LABELLED SPARKLINE -------------------

# sparkLine :: [Float] -> [String]
def sparkLine(xs):
    '''Unicode sparkline summary of a
       list of floating point numbers.
    '''
    def go(xs):
        ys = sorted(xs)
        mn, mx = ys[0], ys[-1]
        n = len(xs)
        mid = n // 2
        w = (mx - mn) / 8
        lbounds = list(map(lambda i: mn + (w * i), range(1, 8)))
        le = curry(operator.le)

        # spark :: Float -> Char
        def spark(x):
            def go(i):
                return '▁▂▃▄▅▆▇'[i]
            return maybe('█')(go)(
                findIndex(le(x))(lbounds)
            )
        return [
            ''.join(map(spark, xs)),
            ' '.join(map(str, xs)),
            '\t'.join([
                'Min ' + str(mn),
                'Mean ' + str(round(mean(xs), 2)),
                'Median ' + str(
                    (ys[mid - 1] + ys[mid]) / 2 if even(n) else (
                        ys[mid]
                    )
                ),
                'Max ' + str(mx)
            ]),
            ''
        ]
    return go(xs) if xs else []


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Tested on some sample lists.
    '''
    print(
        unlines(map(
            compose(compose(unlines, sparkLine), readFloats),
            [
                "0, 1, 19, 20",
                "0, 999, 4000, 4999, 7000, 7999",
                "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1",
                "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"
            ]
        ))
    )


# ------------------------ GENERIC -------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.
       Wrapper containing the result of a computation.
    '''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return {'type': 'Maybe', 'Nothing': True}


# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    def go(f, g):
        def fg(x):
            return f(g(x))
        return fg
    return reduce(go, fs, lambda x: x)


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.
    '''
    return lambda x: lambda y: f(x, y)


# even :: Int -> Bool
def even(x):
    '''True if x is an integer
       multiple of two.
    '''
    return 0 == x % 2


# findIndex :: (a -> Bool) -> [a] -> Maybe Int
def findIndex(p):
    '''Just the first index at which an
       element in xs matches p,
       or Nothing if no elements match.
    '''
    def go(xs):
        try:
            return Just(next(
                i for i, v in enumerate(xs) if p(v)
            ))
        except StopIteration:
            return Nothing()
    return go


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if (
        None is m or m.get('Nothing')
    ) else f(m.get('Just'))


# mean :: [Num] -> Float
def mean(xs):
    '''The arithmetic mean of the numeric
       values in xs.
    '''
    return sum(xs) / float(len(xs))


# readFloats :: String -> [Float]
def readFloats(s):
    '''A list of floats parsed from
       a numeric string delimited by
       commas and/or white space.
    '''
    return list(map(
        float,
        re.split(r'[\s,]+', s)
    ))


# unlines :: [String] -> String
def unlines(xs):
    '''A single string formed by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
