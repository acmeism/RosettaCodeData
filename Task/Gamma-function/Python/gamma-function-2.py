'''Gamma function'''

from functools import reduce


# gamma_ :: [Float] -> Float -> Float
def gamma_(tbl):
    '''Gamma function.'''
    def go(x):
        y = float(x) - 1.0
        return 1.0 / reduce(
            lambda a, x: a * y + x,
            tbl[-2::-1],
            tbl[-1]
        )
    return lambda x: go(x)


# TBL :: [Float]
TBL = [
    1.00000000000000000000, 0.57721566490153286061,
    -0.65587807152025388108, -0.04200263503409523553,
    0.16653861138229148950, -0.04219773455554433675,
    -0.00962197152787697356, 0.00721894324666309954,
    -0.00116516759185906511, -0.00021524167411495097,
    0.00012805028238811619, -0.00002013485478078824,
    -0.00000125049348214267, 0.00000113302723198170,
    -0.00000020563384169776, 0.00000000611609510448,
    0.00000000500200764447, -0.00000000118127457049,
    0.00000000010434267117, 0.00000000000778226344,
    -0.00000000000369680562, 0.00000000000051003703,
    -0.00000000000002058326, -0.00000000000000534812,
    0.00000000000000122678, -0.00000000000000011813,
    0.00000000000000000119, 0.00000000000000000141,
    -0.00000000000000000023, 0.00000000000000000002
]


# TEST ----------------------------------------------------
# main :: IO()
def main():
    '''Gamma function over a range of values.'''

    gamma = gamma_(TBL)
    print(
        fTable(' i -> gamma(i/3):\n')(repr)(lambda x: "%0.7e" % x)(
            lambda x: gamma(x / 3.0)
        )(enumFromTo(1)(10))
    )


# GENERIC -------------------------------------------------

# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# FORMATTING -------------------------------------------------

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
