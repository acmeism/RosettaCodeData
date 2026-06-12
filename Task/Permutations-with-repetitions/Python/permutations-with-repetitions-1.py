'''Permutations of n elements drawn from k values'''

from itertools import product


# replicateM :: Applicative m => Int -> m a -> m [a]
def replicateM(n):
    '''A functor collecting values accumulated by
       n repetitions of m. (List instance only here).
    '''
    def rep(m):
        def go(x):
            return [[]] if 1 > x else (
                liftA2List(lambda a, b: [a] + b)(m)(go(x - 1))
            )
        return go(n)
    return lambda m: rep(m)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Permutations of two elements, drawn from three values'''
    print(
        fTable(main.__doc__ + ':\n')(repr)(showList)(

            replicateM(2)

        )([[1, 2, 3], 'abc'])
    )


# GENERIC FUNCTIONS ---------------------------------------

# liftA2List :: (a -> b -> c) -> [a] -> [b] -> [c]
def liftA2List(f):
    '''The binary operator f lifted to a function over two
       lists. f applied to each pair of arguments in the
       cartesian product of xs and ys.
    '''
    return lambda xs: lambda ys: [
        f(*xy) for xy in product(xs, ys)
    ]


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


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(
        showList(x) if isinstance(x, list) else repr(x) for x in xs
    ) + ']'


# MAIN ---
if __name__ == '__main__':
    main()
