'''Ordered Partitions'''


# partitions :: [Int] -> [[[Int]]]
def partitions(xs):
    '''Ordered partitions of xs.'''
    n = sum(xs)

    def go(s, n, ys):
        return [
            [l] + r
            for (l, rest) in choose(s)(n)(ys[0])
            for r in go(rest, n - ys[0], ys[1:])
        ] if ys else [[]]
    return go(enumFromTo(1)(n), n, xs)


# choose :: [Int] -> Int -> Int -> [([Int], [Int])]
def choose(xs):
    '''(m items chosen from n items, the rest)'''
    def go(xs, n, m):
        f = cons(xs[0])
        choice = choose(xs[1:])(n - 1)
        return [([], xs)] if 0 == m else (
            [(xs, [])] if n == m else (
                [first(f)(x) for x in choice(m - 1)] +
                [second(f)(x) for x in choice(m)]
            )
        )
    return lambda n: lambda m: go(xs, n, m)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tests of the partitions function'''

    f = partitions
    print(
        fTable(main.__doc__ + ':')(
            lambda x: '\n' + f.__name__ + '(' + repr(x) + ')'
        )(
            lambda ps: '\n\n' + '\n'.join(
                '    ' + repr(p) for p in ps
            )
        )(f)([
            [2, 0, 2],
            [1, 1, 1]
        ])
    )


# DISPLAY -------------------------------------------------

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


# GENERIC -------------------------------------------------

# cons :: a -> [a] -> [a]
def cons(x):
    '''Construction of a list from x as head,
       and xs as tail.
    '''
    return lambda xs: [x] + xs


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# first :: (a -> b) -> ((a, c) -> (b, c))
def first(f):
    '''A simple function lifted to a function over a tuple,
       with f applied only the first of two values.
    '''
    return lambda xy: (f(xy[0]), xy[1])


# second :: (a -> b) -> ((c, a) -> (c, b))
def second(f):
    '''A simple function lifted to a function over a tuple,
       with f applied only the second of two values.
    '''
    return lambda xy: (xy[0], f(xy[1]))


# MAIN ---
if __name__ == '__main__':
    main()
