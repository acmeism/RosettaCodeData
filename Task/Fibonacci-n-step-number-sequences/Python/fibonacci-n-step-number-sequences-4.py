'''Fibonacci n-step number sequences'''


# fibInit :: Int -> [Int]
def fibInit(n):
    '''Initial values for a
       Fibonacci n-step number sequence
       of order n.
    '''
    return [1] + [
        pow(2, x) for x
        in enumFromTo(0)(n - 2)
    ]


# takeNFibs :: [Int] -> Int -> [Int]
def takeNFibs(xs):
    '''Given the initial members, the
       continuation to the nth member of
       a Fibonacci n-step number sequence.
    '''
    def go(xs, n):
        h, *t = xs
        return [h] + (
            go(t + [sum(xs)], n - 1)
        ) if 0 < n and xs else []
    return lambda n: go(xs, n)


# TESTS ----------------------------------------------------
# main :: IO ()
def main():
    '''Various n-step sequences'''

    print(
        fTable(__doc__ + ':\n')(fst)(showList)(
            compose(flip(takeNFibs)(15))(snd)
        )([('Lucas', [2, 1])] + list(zip(
            [k + 'nacci' for k in words(
                'fibo tribo tetra penta hexa hepta octo nona deca'
            )],
            [fibInit(n) for n in enumFromTo(2)(10)]
        )))
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


# flip :: (a -> b -> c) -> b -> a -> c
def flip(f):
    '''The curried function f with its
       arguments reversed.'''
    return lambda a: lambda b: f(b)(a)


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(str(x) for x in xs) + ']'


# words :: String -> [String]
def words(s):
    '''A list of words delimited by characters
       representing white space.'''
    return s.split()


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


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# MAIN ---
if __name__ == '__main__':
    main()
