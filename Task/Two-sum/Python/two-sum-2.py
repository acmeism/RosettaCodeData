'''Finding two integers that sum to a target value.'''

from itertools import (product)


# sumTwo :: [Int] -> Int -> [(Int, Int)]
def sumTwo(xs):
    '''All the pairs of integers in xs which
       sum to n.
    '''
    def go(n):
        ixs = list(enumerate(xs))
        return [
            (fst(x), fst(y)) for (x, y) in (
                product(ixs, ixs[1:])
            ) if fst(x) < fst(y) and n == snd(x) + snd(y)
        ]
    return lambda n: go(n)


# TEST ----------------------------------------------------

# main :: IO ()
def main():
    '''Tests'''

    xs = [0, 2, 11, 19, 90, 10]

    print(
        fTable(
            'The indices of any two integers drawn from ' + repr(xs) +
            '\nthat sum to a given value:\n'
        )(str)(
            lambda x: str(x) + ' = ' + ', '.join(
                ['(' + str(xs[a]) + ' + ' + str(xs[b]) + ')' for a, b in x]
            ) if x else '(none)'
        )(
            sumTwo(xs)
        )(enumFromTo(10)(25))
    )


# GENERIC -------------------------------------------------

# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


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


# MAIN ---
if __name__ == '__main__':
    main()
