'''Binary strings for integers'''


# showBinary :: Int -> String
def showBinary(n):
    '''Binary string representation of an integer.'''
    def binaryChar(n):
        return '1' if n != 0 else '0'
    return showIntAtBase(2)(binaryChar)(n)('')


# TEST ----------------------------------------------------

# main :: IO()
def main():
    '''Test'''

    print('Mapping showBinary over integer list:')
    print(unlines(map(
        showBinary,
        [5, 50, 9000]
    )))

    print(tabulated(
        '\nUsing showBinary as a display function:'
    )(str)(showBinary)(
        lambda x: x
    )([5, 50, 9000]))


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# showIntAtBase :: Int -> (Int -> String) -> Int -> String -> String
def showIntAtBase(base):
    '''String representing a non-negative integer
       using the base specified by the first argument,
       and the character representation specified by the second.
       The final argument is a (possibly empty) string to which
       the numeric string will be prepended.'''
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


# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
                f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join(
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        )
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


if __name__ == '__main__':
    main()
