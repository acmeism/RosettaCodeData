'''Encoding Roman Numerals'''

from functools import reduce
from itertools import chain


# romanFromInt ::  Int -> String
def romanFromInt(n):
    '''A string of Roman numerals encoding an integer.'''
    def go(a, ms):
        m, s = ms
        q, r = divmod(a, m)
        return (r, s * q)

    return concat(snd(mapAccumL(go)(n)(
        zip([
            1000, 900, 500, 400, 100, 90, 50,
            40, 10, 9, 5, 4, 1
        ], [
            'M', 'CM', 'D', 'CD', 'C', 'XC', 'L',
            'XL', 'X', 'IX', 'V', 'IV', 'I'
        ])
    )))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Sample of years'''
    for s in [
            romanFromInt(x) for x in [
                1666, 1990, 2008, 2016, 2018, 2020
            ]
    ]:
        print(s)


# ------------------ GENERIC FUNCTIONS -------------------

# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xxs):
    '''The concatenation of all the elements in a list.'''
    xs = list(chain.from_iterable(xxs))
    unit = '' if isinstance(xs, str) else []
    return unit if not xs else (
        ''.join(xs) if isinstance(xs[0], str) else xs
    )


# mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
def mapAccumL(f):
    '''A tuple of an accumulation and a list derived by a
       combined map and fold,
       with accumulation from left to right.'''
    def go(a, x):
        tpl = f(a[0], x)
        return (tpl[0], a[1] + [tpl[1]])
    return lambda acc: lambda xs: (
        reduce(go, xs, (acc, []))
    )


# snd :: (a, b) -> b
def snd(tpl):
    '''Second component of a tuple.'''
    return tpl[1]


# MAIN ---
if __name__ == '__main__':
    main()
