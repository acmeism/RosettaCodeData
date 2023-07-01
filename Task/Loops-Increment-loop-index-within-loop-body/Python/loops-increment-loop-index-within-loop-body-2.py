'''Loops/Increment loop index within loop body.'''

from itertools import islice, takewhile
from functools import reduce
import operator


# main :: IO ()
def main():
    '''Defines a list value, while printing a stream
       of intermediate values during computation.
    '''
    gt = curry(operator.gt)
    fst = operator.itemgetter(0)

    list(takewhile(compose(gt(43), fst), series()))


# series :: (Int, Int) -> [(Int, Int)]
def series():
    '''Non finite series, defined as a generator
       with IO side-effects (to the print channel).
    '''
    def go(tpl):
        if isPrime(tpl[1]):
            # Side effect.
            print(showTuple(tpl))
            # Value.
            return splitArrow(succ)(dbl)(tpl)
        else:
            return secondArrow(succ)(tpl)

    return iterate(go)(
        (1, 42)
    )


# isPrime :: Int -> Bool
def isPrime(n):
    '''True if n is prime.'''
    if n in (2, 3):
        return True
    if 2 > n or 0 == n % 2:
        return False
    if 9 > n:
        return True
    if 0 == n % 3:
        return False

    def p(x):
        return 0 == n % x or 0 == n % (2 + x)

    return not any(map(p, range(5, 1 + int(n ** 0.5), 6)))


# showTuple :: (Int, Int) -> String
def showTuple(tpl):
    '''Second integer shown with comma-chunked digits.'''
    return '{:2} -> {:20,}'.format(*tpl)


# -------------------------GENERIC-------------------------

# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    return lambda x: reduce(
        lambda a, f: f(a),
        fs[::-1], x
    )


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.
    '''
    return lambda x: lambda y: f(x, y)


# dbl :: Int -> Int -> Int
def dbl(x):
    '''2 * x'''
    return x + x


# drop :: Int -> [a] -> [a]
# drop :: Int -> String -> String
def drop(n):
    '''The sublist of xs beginning at
       (zero-based) index n.
    '''
    def go(xs):
        take(n)(xs)
        return xs
    return go


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated
       applications of f to x.
    '''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return go


# secondArrow :: (b -> c) -> (a, b...) -> (a, c ...)
def secondArrow(f):
    '''A simple function lifted to one which applies
       to a tuple, transforming only its second value.
    '''
    return lambda tpl: (tpl[0], f(tpl[1]))


# splitArrow (***) :: (a -> b) -> (c -> d) -> ((a, c) -> (b, d))
def splitArrow(f):
    '''A function from (x, y) to a tuple of (f(x), g(y))
    '''
    return lambda g: lambda tpl: (f(tpl[0]), g(tpl[1]))


# succ :: Enum a => a -> a
def succ(x):
    '''The successor of a value.
       For numeric types, (1 +).
    '''
    return 1 + x


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: list(islice(xs, n))


# MAIN ---
if __name__ == '__main__':
    main()
