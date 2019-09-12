'''Harshad or Niven series'''

from itertools import dropwhile, islice


# harshads :: () -> Gen [Int]
def harshads():
    '''Harshad series.'''
    x = 1
    while True:
        if 0 == (x % digitSum(x)):
            yield x
        x = 1 + x


# digitSum :: Int -> Int
def digitSum(n):
    '''The Sum of the decimal digits of n.'''
    def plusDigit(ra):
        r = ra[0]
        return (r // 10, ra[1] + (r % 10))

    def remZero(ra):
        return 0 == ra[0]

    return until(remZero)(plusDigit)(
        (n, 0)
    )[1]


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


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


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
