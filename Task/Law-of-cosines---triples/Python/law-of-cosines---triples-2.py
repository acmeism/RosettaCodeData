from itertools import (starmap)


def f90(dct):
    return lambda x2, ab, a, b: dct.get(x2, None)


def f60(dct):
    return lambda x2, ab, a, b: dct.get(x2 - ab, None)


def f120(dct):
    return lambda x2, ab, a, b: dct.get(x2 + ab, None)


def f60unequal(dct):
    return lambda x2, ab, a, b: (
        dct.get(x2 - ab, None) if a != b else None
    )


# triangles :: Dict -> (Int -> Int -> Int -> Int -> Maybe Int)
#                   -> [String]
def triangles(f, n):
    upto = enumFromTo(1)
    xs = upto(n)
    dctSquares = dict(zip(xs, [x**2 for x in xs]))
    dctRoots = {v: k for k, v in dctSquares.items()}
    fr = f(dctRoots)
    dct = {}
    for a in xs:
        a2 = dctSquares[a]
        for b in upto(a):
            suma2b2 = a2 + dctSquares[b]
            c = fr(suma2b2, a * b, a, b)
            if (c is not None):
                dct[str(sorted([a, b, c]))] = 1
    return list(dct.keys())


def main():
    print(
        'Triangles of maximum side 13\n\n' +
        unlines(
            zipWith(
                lambda f, n: (
                    lambda ks=triangles(f, 13): (
                        str(len(ks)) + ' solutions for ' +
                        str(n) + ' degrees:\n' +
                        unlines(ks) + '\n'
                    )
                )()
            )([f120, f90, f60])
             ([120, 90, 60])
        ) + '\n\n' +
        '60 degrees - uneven triangles of maximum side 10000. Total:\n' +
        str(len(triangles(f60unequal, 10000)))
    )


# GENERIC --------------------------------------------------------------

# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    return lambda n: list(range(m, 1 + n))


# unlines :: [String] -> String
def unlines(xs):
    return '\n'.join(xs)


# zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
def zipWith(f):
    return lambda xs: lambda ys: (
        list(starmap(f, zip(xs, ys)))
    )


if __name__ == '__main__':
    main()
