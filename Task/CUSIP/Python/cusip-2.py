'''CUSIP'''

from itertools import (cycle, islice, starmap)
from functools import (reduce)
from operator import (add)
from enum import (Enum)


# isCusip :: Dict -> String -> Bool
def isCusip(dct):
    '''Test for the validity of a CUSIP string in the
       context of a supplied dictionary of char values'''
    def go(s):
        ns = [dct[c] for c in list(s) if c in dct]
        return 9 == len(ns) and (
            ns[-1] == (
                10 - (
                    sum(zipWith(
                        lambda f, x: add(*divmod(f(x), 10))
                    )(cycle([identity, double]))(
                        take(8)(ns)
                    )) % 10
                )
            ) % 10
        )
    return go


# cusipCharDict :: () -> Dict Char Int
def cusipCharDict():
    '''Dictionary of integer values for CUSIP characters'''
    def kv(a, ic):
        i, c = ic
        a[c] = i
        return a
    return reduce(
        kv,
        enumerate(
            enumFromTo('0')('9') + (
                enumFromTo('A')('Z') + list('*&#')
            )
        ),
        {}
    )


# TEST -------------------------------------------------
# main :: IO ()
def main():
    '''Tests'''

    # cusipTest :: String -> Bool
    cusipTest = isCusip(cusipCharDict())

    print(
        tabulated('Valid as CUSIP string:')(
            cusipTest
        )([
            '037833100',
            '17275R102',
            '38259P508',
            '594918104',
            '68389X106',
            '68389X105'
        ])
    )

# GENERIC -------------------------------------------------


# double :: Num -> Num
def double(x):
    '''Wrapped here as a function for the zipWith expression'''
    return 2 * x


# enumFromTo :: Enum a => a -> a -> [a]
def enumFromTo(m):
    '''Enumeration of values [m..n]'''
    def go(x, y):
        t = type(m)
        i = fromEnum(x)
        d = 0 if t != float else (x - i)
        return list(map(
            lambda x: toEnum(t)(d + x),
            range(i, 1 + fromEnum(y))
        ) if int != t else range(x, 1 + y))
    return lambda n: go(m, n)


# fromEnum :: Enum a => a -> Int
def fromEnum(x):
    '''Index integer for enumerable value.'''
    return ord(x) if str == type(x) else (
        x.value if isinstance(x, Enum) else int(x)
    )


# mul :: Num -> Num -> Num
def mul(x):
    '''Function version of (*) operator;
       a curried equivalent of operator.mul'''
    return lambda y: x * y


# identity :: a -> a
def identity(x):
    '''The identity function.
       The usual 'id' is reserved in Python.'''
    return x


# tabulated :: String -> (a -> b) -> [a] -> String
def tabulated(s):
    '''heading -> function -> input List -> tabulated output string'''
    def go(f, xs):
        def width(x):
            return len(str(x))
        w = width(max(xs, key=width))
        return s + '\n' + '\n'.join([
            str(x).rjust(w, ' ') + ' -> ' + str(f(x)) for x in xs
        ])
    return lambda f: lambda xs: go(f, xs)


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else list(islice(xs, n))
    )


# toEnum :: Type -> Int -> a
def toEnum(t):
    '''Enumerable value from index integer'''
    dct = {
        int: int,
        float: float,
        str: chr,
        bool: bool
    }
    return lambda x: dct[t](x) if t in dct else t(x)


# zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
def zipWith(f):
    '''Zipping with a custom (rather than tuple) function'''
    return lambda xs: lambda ys: (
        list(starmap(f, zip(xs, ys)))
    )


# MAIN ---
if __name__ == '__main__':
    main()
