'''Sum digits of an integer'''

from functools import reduce


# digitSum :: Int -> Int -> Int
def digitSum(base):
    '''The sum of the digits of a
       natural number in a given base.
    '''
    return lambda n: reduce(
        lambda a, x: a + digitToInt(x),
        showIntAtBase(base)(digitChar)(n)(''),
        0
    )


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Digit sums of numbers in bases 10 and 16:'''

    print(
        fTable(main.__doc__)(
            lambda nb: showIntAtBase(nb[0])(
                digitChar
            )(nb[1])(' in base ') + str(nb[0])
        )(repr)(
            uncurry(digitSum)
        )([(10, 1), (10, 10), (16, 0xfe), (16, 0xf0e)])
    )


# -------------------------DISPLAY-------------------------

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


# -------------------------GENERIC-------------------------

# digitChar :: Int to Char
def digitChar(n):
    '''A digit char for integers drawn from [0..15]'''
    return ' ' if 0 > n or 15 < n else '0123456789abcdef'[n]


# digitToInt :: Char -> Int
def digitToInt(c):
    '''The integer value of any digit character
       drawn from the 0-9, A-F or a-f ranges.
    '''
    oc = ord(c)
    if 48 > oc or 102 < oc:
        return None
    else:
        dec = oc - 48   # ord('0')
        hexu = oc - 65  # ord('A')
        hexl = oc - 97  # ord('a')
    return dec if 9 >= dec else (
        10 + hexu if 0 <= hexu <= 5 else (
            10 + hexl if 0 <= hexl <= 5 else None
        )
    )


# showIntAtBase :: Int -> (Int -> String) -> Int -> String -> String
def showIntAtBase(base):
    '''String representation of an integer in a given base,
       using a supplied function for the string representation
       of digits.
    '''
    def wrap(toChr, n, rs):
        def go(nd, r):
            n, d = nd
            r_ = toChr(d) + r
            return go(divmod(n, base), r_) if 0 != n else r_
        return 'unsupported base' if 1 >= base else (
            'negative number' if 0 > n else (
                go(divmod(n, base), rs))
        )
    return lambda toChr: lambda n: lambda rs: (
        wrap(toChr, n, rs)
    )


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    '''A function over a tuple,
       derived from a curried function.
    '''
    return lambda tpl: f(tpl[0])(tpl[1])


# MAIN ---
if __name__ == '__main__':
    main()
