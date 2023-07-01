'''Middle 3 digits'''


# mid3digits :: Int -> Either String String
def mid3digits(n):
    '''Either the middle three digits,
       or an explanatory string.'''
    m = abs(n)
    s = str(m)
    return Left('Less than 3 digits') if (100 > m) else (
        Left('Even digit count') if even(len(s)) else Right(
            s[(len(s) - 3) // 2:][0:3]
        )
    )


# TEST ----------------------------------------------------
def main():
    '''Test'''

    def bracketed(x):
        return '(' + str(x) + ')'

    print(
        tabulated('Middle three digits, where defined:\n')(str)(
            either(bracketed)(str)
        )(mid3digits)([
            123, 12345, 1234567, 987654321, 10001, -10001, -123,
            -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0
        ])
    )


# GENERIC -------------------------------------------------

# Left :: a -> Either a b
def Left(x):
    '''Constructor for an empty Either (option type) value
       with an associated string.'''
    return {'type': 'Either', 'Right': None, 'Left': x}


# Right :: b -> Either a b
def Right(x):
    '''Constructor for a populated Either (option type) value'''
    return {'type': 'Either', 'Left': None, 'Right': x}


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Function composition.'''
    return lambda f: lambda x: g(f(x))


# either :: (a -> c) -> (b -> c) -> Either a b -> c
def either(fl):
    '''The application of fl to e if e is a Left value,
       or the application of fr to e if e is a Right value.'''
    return lambda fr: lambda e: fl(e['Left']) if (
        None is e['Right']
    ) else fr(e['Right'])


# even :: Int -> Bool
def even(x):
    '''Is x even ?'''
    return 0 == x % 2


# tabulated :: String -> (b -> String) -> (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
                f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(str), xs))
        return s + '\n' + '\n'.join(
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        )
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


if __name__ == '__main__':
    main()
