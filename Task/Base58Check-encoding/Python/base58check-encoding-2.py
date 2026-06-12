'''Base 58 check encoding'''

from functools import reduce
import itertools
import enum


# baseEncode :: [Char] -> (Integer -> String)
def baseEncode(cs):
    '''Given the character set for a given base,
       returns a function from a integer to a string
       representing that integer in the base
       specified by the length of the character set.
    '''
    return lambda n: showIntAtBase(len(cs))(
        index(cs)
    )(n)('')


# TESTS ---------------------------------------------------
# main :: IO ()
def main():
    '''Tests of base58 encoding.'''

    # base58Encode :: Integer -> String
    base58Encode = baseEncode(
        reduce(
            lambda a, xy: a + uncurry(enumFromTo)(xy),
            [
                ('1', '9'),
                ('A', 'H'), ('J', 'N'), ('P', 'Z'),
                ('a', 'k'), ('m', 'z')
            ],
            []
        )
    )

    print(
        fTable(__doc__ + ':\n')(hex)(base58Encode)(stet)([
            25420294593250030202636073700053352635053786165627414518,
            0x61,
            0x626262,
            0x636363,
            0x73696d706c792061206c6f6e6720737472696e67,
            0x516b6fcd0f,
            0xbf4f89001e670274dd,
            0x572e4794,
            0xecac89cad93923c02321,
            0x10c8511e
        ])
    )


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


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
    Enum = enum.Enum
    return ord(x) if str == type(x) else (
        x.value if isinstance(x, Enum) else int(x)
    )


# fTable :: String -> (a -> String) ->
#                     (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function ->
                 fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + (' -> ') + fxShow(f(x))
            for x in xs
        ])
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# index (!!) :: [a] -> Int -> a
def index(xs):
    '''Item at given (zero-based) index.'''
    islice = itertools.islice
    return lambda n: None if 0 > n else (
        xs[n] if (
            hasattr(xs, "__getitem__")
        ) else next(islice(xs, n, None))
    )


# showIntAtBase :: Int -> (Int -> String) -> Int -> String -> String
def showIntAtBase(base):
    '''String representation of an integer in a given base,
       using a supplied function for the string representation
       of digits.'''
    def wrap(toChr, n, rs):
        def go(nd, r):
            n, d = nd
            r_ = toChr(d) + r
            return go(divmod(n, base), r_) if 0 != n else r_
        return 'unsupported base' if 1 >= base else (
            'negative number' if 0 > n else (
                go(divmod(n, base), rs))
        )
    return lambda toChr: lambda n: lambda rs: (
        wrap(toChr, n, rs)
    )


# stet :: a -> a
def stet(x):
    '''The identity function.
       The usual 'id' is reserved in Python.'''
    return x


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    '''A function over a tuple,
       derived from a default or
       curried function.'''
    return lambda xy: f(xy[0])(xy[1])


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


# MAIN ---
if __name__ == '__main__':
    main()
