from functools import (reduce)


# baseDigitSum :: Int -> Int -> Int
def baseDigitSum(base):
    return lambda n: sumFromDigitString(
        showIntAtBase(base)(
            intToDigit
        )(n)('')
    )


# sumFromDigitString :: String -> Int
def sumFromDigitString(s):
    return reduce(
        lambda a, c: a + digitToInt(c),
        list(s), 0
    )


# TESTS ---------------------------------------------------
def main():
    print('Base 10:')
    print (unlines(map(
        showfx('d', 'd')(
            baseDigitSum(10)
        ),
        [1, 1234, 1235, 123045]
    )))

    print('\nBase 16:')
    print (unlines(map(
        showfx('x', 'd')(
            baseDigitSum(16)
        ),
        [0xfe, 0xf0e]
    )))


# GENERIC -------------------------------------------------


# digitToInt :: Char -> Int
def digitToInt(c):
    oc = ord(c)
    if 48 > oc or 102 < oc:
        return None
    else:
        dec = oc - ord('0')
        hexu = oc - ord('A')
        hexl = oc - ord('a')
    return dec if 9 >= dec else (
        10 + hexu if 0 <= hexu and 5 >= hexu else (
            10 + hexl if 0 <= hexl and 5 >= hexl else None
        )
    )


# intToDigit :: Int -> Char
def intToDigit(n):
    return '0123456789ABCDEF'[n] if (
        n >= 0 and n < 16
    ) else '?'


# showfx :: (String, String) -> (a -> b) -> a -> String
def showfx(fmt, fmt2):
    return lambda f: lambda x: format(x, fmt) + (
        ' -> ' + format(f(x), fmt2)
    )


# showIntAtBase :: Int -> (Int -> String) -> Int -> String -> String
def showIntAtBase(base):
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


# unlines :: [String] -> String
def unlines(xs):
    return '\n'.join(xs)


if __name__ == '__main__':
    main()
