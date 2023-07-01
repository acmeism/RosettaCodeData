from functools import (reduce)
from itertools import (chain)


# modInv :: Int -> Int -> Maybe Int
def modInv(a):
    return lambda m: (
        lambda ig=gcdExt(a)(m): (
            lambda i=ig[0]: (
                Just(i + m if 0 > i else i) if 1 == ig[2] else (
                    Nothing()
                )
            )
        )()
    )()


# gcdExt :: Int -> Int -> (Int, Int, Int)
def gcdExt(x):
    def go(a, b):
        if 0 == b:
            return (1, 0, a)
        else:
            (q, r) = divmod(a, b)
            (s, t, g) = go(b, r)
        return (t, s - q * t, g)
    return lambda y: go(x, y)


#  TEST ---------------------------------------------------

# Numbers between 2010 and 2015 which do yield modular inverses for 42:

# main :: IO ()
def main():
    print (
        mapMaybe(
            lambda y: bindMay(modInv(42)(y))(
                lambda mInv: Just((y, mInv))
            )
        )(
            enumFromTo(2010)(2025)
        )
    )

# -> [(2011, 814), (2015, 48), (2017, 1969), (2021, 1203)]


# GENERIC ABSTRACTIONS ------------------------------------


# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    return lambda n: list(range(m, 1 + n))


# bindMay (>>=) :: Maybe  a -> (a -> Maybe b) -> Maybe b
def bindMay(m):
    return lambda mf: (
        m if m.get('Nothing') else mf(m.get('Just'))
    )


# Just :: a -> Maybe a
def Just(x):
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# mapMaybe :: (a -> Maybe b) -> [a] -> [b]
def mapMaybe(mf):
    return lambda xs: reduce(
        lambda a, x: maybe(a)(lambda j: a + [j])(mf(x)),
        xs,
        []
    )


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    return lambda f: lambda m: v if m.get('Nothing') else (
        f(m.get('Just'))
    )


# Nothing :: Maybe a
def Nothing():
    return {'type': 'Maybe', 'Nothing': True}


# MAIN ---
main()
