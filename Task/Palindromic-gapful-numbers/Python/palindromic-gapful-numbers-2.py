'''Palindromic gapful numbers'''

from itertools import chain, count, islice, tee
from functools import reduce


# palindromicGapfuls :: () -> [Int]
def palindromicGapfuls():
    '''A non-finite series of gapful palindromic numbers.
    '''
    def derived(digitsEven):
        '''A palindrome of an even or odd number of digits,
           obtained by appending either all or just the tail
           of the reversed digits of n.
        '''
        def go(x):
            s = str(x)
            r = s[::-1]
            return int((s + r) if digitsEven else (s + r[1:]))
        return go

    return filter(
        lambda n: 0 == n % (int(str(n)[0]) * 10 + (n % 10)),
        mergeInOrder(
            map(derived(False), count(10))
        )(map(derived(True), count(10)))
    )


# --------------------------TESTS--------------------------
# main :: IO ()
def main():
    '''Various samples of gapful palindromes grouped by final digit.'''

    tpl = tee(palindromicGapfuls(), 9)

    # sample :: (String, Int, Int) -> String
    def sample(label, dropped, taken):
        return fTable(label)(compose(cons(' '), str))(
            compose(unwords, map_(str))
        )(
            compose(
                take(taken),
                drop(dropped),
                lambda i: filter(
                    lambda x: i == x % 10,
                    tpl[i - 1]
                )
            )
        )(enumFromTo(1)(9))

    print(
        '\n\n'.join(map(lambda x: sample(*x), [
            ('First 20 samples of gapful palindromes ' +
             '(> 100) by last digit:', 0, 20),

            ('Last 15 of first 100 gapful palindromes ' +
             '(> 100) by last digit:', 65, 15),

            ('Last 10 of first 1000 gapful palindromes ' +
             '(> 100) by last digit:', 890, 10)
        ]))
    )

# ------------------------DISPLAY -------------------------


# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
       f -> xs -> tabular string.
    '''
    def go(xShow, fxShow, f, xs):
        ys = [xShow(x) for x in xs]
        w = max(map(len, ys))
        return s + '\n' + '\n'.join(map(
            lambda x, y: y.rjust(w, ' ') + ': ' + fxShow(f(x)),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# ------------------------GENERIC--------------------------

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


# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    def go(f, g):
        return lambda x: f(g(x))
    return reduce(go, fs, lambda x: x)


# cons :: a -> [a] -> [a]
def cons(x):
    '''A list string or iterator constructed
       from x as head, and xs as tail.
    '''
    return lambda xs: [x] + xs if (
        isinstance(xs, list)
    ) else x + xs if (
        isinstance(xs, str)
    ) else chain([x], xs)


# drop :: Int -> [a] -> [a]
def drop(n):
    '''The sublist of xs beginning at
       (zero-based) index n.
    '''
    def go(xs):
        take(n)(xs)
        return xs
    return go


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    '''Enumeration of integer values [m..n]'''
    def go(n):
        return list(range(m, 1 + n))
    return go


# map :: (a -> b) -> [a] -> [b]
def map_(f):
    '''The list obtained by applying f
       to each element of xs.
    '''
    return lambda xs: [f(x) for x in xs]


# mergeInOrder :: Gen [Int] -> Gen [Int] -> Gen [Int]
def mergeInOrder(ga):
    '''An ordered, non-finite, stream of integers
       obtained by merging two other such streams.
    '''
    def go(ma, mb):
        a = ma
        b = mb
        while not a['Nothing'] and not b['Nothing']:
            (a1, a2) = a['Just']
            (b1, b2) = b['Just']
            if a1 < b1:
                yield a1
                a = uncons(a2)
            else:
                yield b1
                b = uncons(b2)

    return lambda gb: go(uncons(ga), uncons(gb))


# take :: Int -> [a] -> [a]
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: list(islice(xs, n))


# uncons :: [a] -> Maybe (a, [a])
def uncons(xs):
    '''The deconstruction of a non-empty list
       (or generator stream) into two parts:
       a head value, and the remaining values.
    '''
    nxt = take(1)(xs)
    return Just((nxt[0], xs)) if nxt else Nothing()


# unwords :: [String] -> String
def unwords(xs):
    '''A space-separated string derived
       from a list of words.
    '''
    return ' '.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
