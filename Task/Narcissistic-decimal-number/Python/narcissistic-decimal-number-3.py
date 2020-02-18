'''Narcissistic decimal numbers'''

from itertools import chain
from functools import reduce


# main :: IO ()
def main():
    '''Narcissistic numbers of digit lengths 1 to 7'''
    print(
        fTable(main.__doc__ + ':\n')(str)(str)(
            narcissiOfLength
        )(enumFromTo(1)(7))
    )


# narcissiOfLength :: Int -> [Int]
def narcissiOfLength(n):
    '''List of Narcissistic numbers of
       (base 10) digit length n.
    '''
    return [
        x for x in digitPowerSums(n)
        if isDaffodil(n)(x)
    ]


# digitPowerSums :: Int -> [Int]
def digitPowerSums(e):
    '''The subset of integers of e digits that are potential narcissi.
       (Flattened leaves of a tree of unique digit combinations, in which
       order is not significant. The sum is independent of the sequence.)
    '''
    powers = [(x, x ** e) for x in enumFromTo(0)(9)]

    def go(n, parents):
        return go(
            n - 1,
            chain.from_iterable(map(
                lambda pDigitSum: (
                    map(
                        lambda lDigitSum: (
                            lDigitSum[0],
                            lDigitSum[1] + pDigitSum[1]
                        ),
                        powers[0: 1 + pDigitSum[0]]
                    )
                ),
                parents
            )) if parents else powers
        ) if 0 < n else parents

    return [xs for (_, xs) in go(e, [])]


# isDaffodil :: Int -> Int -> Bool
def isDaffodil(e):
    '''True if n is a narcissistic number
       of decimal digit length e.
    '''
    def go(n):
        ds = digitList(n)
        return e == len(ds) and n == powerSum(e)(ds)
    return lambda n: go(n)


# powerSum :: Int -> [Int] -> Int
def powerSum(e):
    '''The sum of a list obtained by raising
       each element of xs to the power of e.
    '''
    return lambda xs: reduce(
        lambda a, x: a + x ** e,
        xs, 0
    )


# -----------------------FORMATTING------------------------

# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
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


# GENERIC -------------------------------------------------

# digitList :: Int -> [Int]
def digitList(n):
    '''A decomposition of n into a
       list of single-digit integers.
    '''
    def go(x):
        return go(x // 10) + [x % 10] if x else []
    return go(n) if n else [0]


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    def go(n):
        return list(range(m, 1 + n))
    return lambda n: go(n)


# MAIN ---
if __name__ == '__main__':
    main()
