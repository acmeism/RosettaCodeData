'''Harshad or Niven series'''

from itertools import chain, count, dropwhile, islice


# harshads :: () -> [Int]
def harshads():
    '''Harshad series'''
    def go(x):
        return [x] if 0 == (x % digitSum(x)) else []
    return chain.from_iterable(
        map(go, count(1))
    )


# digitSum :: Int -> Int
def digitSum(n):
    '''Sum of the decimal digits of n.'''
    def go(x):
        return Nothing() if 0 == x else Just(divmod(x, 10))
    return sum(unfoldl(go)(n))


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''First 20, and first above 1000.'''

    def firstTwenty(xs):
        return take(20)(xs)

    def firstAbove1000(xs):
        return take(1)(
            dropwhile(lambda x: 1000 >= x, xs)
        )

    print(
        fTable(__doc__ + ':\n')(
            lambda x: x.__name__
        )(showList)(lambda f: f(harshads()))([
            firstTwenty,
            firstAbove1000
        ])
    )


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.
       Wrapper containing the result of a computation.
    '''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return {'type': 'Maybe', 'Nothing': True}


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
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
       When f returns Nothing, the completed list is returned.
    '''
    def go(v):
        x, r = v, v
        xs = []
        while True:
            mb = f(x)
            if mb.get('Nothing'):
                return xs
            else:
                x, r = mb.get('Just')
                xs.insert(0, r)
        return xs
    return lambda x: go(x)


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
    return '[' + ','.join(repr(x) for x in xs) + ']'


# MAIN ---
if __name__ == '__main__':
    main()
