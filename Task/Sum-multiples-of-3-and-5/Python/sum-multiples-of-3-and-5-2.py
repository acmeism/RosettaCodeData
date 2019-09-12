'''Summed multiples of 3 and 5 up to n'''


# sum35 :: Int -> Int
def sum35(n):
    '''Sum of all positive multiples
       of 3 or 5 below n.
    '''
    f = sumMults(n)
    return f(3) + f(5) - f(15)


# sumMults :: Int -> Int -> Int
def sumMults(n):
    '''Area under a straight line between
       the first multiple and the last.
    '''
    def go(n, m):
        n1 = (n - 1) // m
        return (m * n1 * (n1 + 1)) // 2
    return lambda x: go(n, x)


# TEST ----------------------------------------------------
def main():
    '''Tests for [10^1 .. 10^5], and [10^8 .. 10^25]
    '''
    print(
        fTable(__doc__ + ':\n')(lambda x: '10E' + str(x))(
            str
        )(compose(sum35)(lambda x: 10**x))(
            enumFromTo(1)(5) + enumFromTo(18)(25)
        )
    )


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# fTable :: String -> (a -> String) ->
#                     (b -> String) ->
#        (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        ])
    return lambda xShow: lambda fxShow: (
        lambda f: lambda xs: go(
            xShow, fxShow, f, xs
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
