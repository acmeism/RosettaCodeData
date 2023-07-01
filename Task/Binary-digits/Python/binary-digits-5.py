'''Decomposition of an integer to a string of booleans.'''


# boolsFromInt :: Int -> [Bool]
def boolsFromInt(n):
    '''List of booleans derived by binary
       decomposition of an integer.'''
    def go(x):
        (q, r) = divmod(x, 2)
        return Just((q, bool(r))) if x else Nothing()
    return unfoldl(go)(n)


# stringFromBools :: [Bool] -> String
def stringFromBools(xs):
    '''Binary string representation of a
       list of boolean values.'''
    def oneOrZero(x):
        return '1' if x else '0'
    return ''.join(map(oneOrZero, xs))


# TEST ----------------------------------------------------
# main :: IO()
def main():
    '''Test'''

    binary = compose(stringFromBools)(boolsFromInt)

    print('Mapping a composed function:')
    print(unlines(map(
        binary,
        [5, 50, 9000]
    )))

    print(
        tabulated(
            '\n\nTabulating a string display from binary data:'
        )(str)(stringFromBools)(
            boolsFromInt
        )([5, 50, 9000])
    )


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


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


# unfoldl(lambda x: Just(((x - 1), x)) if 0 != x else Nothing())(10)
# -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
def unfoldl(f):
    '''Dual to reduce or foldl.
       Where these reduce a list to a summary value, unfoldl
       builds a list from a seed value.
       Where f returns Just(a, b), a is appended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns Nothing, the completed list is returned.'''
    def go(v):
        xr = v, v
        xs = []
        while True:
            mb = f(xr[0])
            if mb.get('Nothing'):
                return xs
            else:
                xr = mb.get('Just')
                xs.insert(0, xr[1])
        return xs
    return lambda x: go(x)


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# MAIN -------------------------------------------------
if __name__ == '__main__':
    main()
