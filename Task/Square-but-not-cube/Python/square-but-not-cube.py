# nonCubeSquares :: Int -> [(Int, Bool)]
def nonCubeSquares(n):
    upto = enumFromTo(1)
    ns = upto(n)
    setCubes = set(x ** 3 for x in ns)
    ms = upto(n + len(set(x * x for x in ns).intersection(
        setCubes
    )))
    return list(tuple([x * x, x in setCubes]) for x in ms)


# squareListing :: [(Int, Bool)] -> [String]
def squareListing(xs):
    justifyIdx = justifyRight(len(str(1 + len(xs))))(' ')
    justifySqr = justifyRight(1 + len(str(xs[-1][0])))(' ')
    return list(
        '(' + str(1 + idx) + '^2 = ' + str(n) +
        ' = ' + str(round(n ** (1 / 3))) + '^3)' if bln else (
            justifyIdx(1 + idx) + ' ->' +
            justifySqr(n)
        )
        for idx, (n, bln) in enumerate(xs)
    )


def main():
    print(
        unlines(
            squareListing(
                nonCubeSquares(30)
            )
        )
    )


# GENERIC ------------------------------------------------------------------

# enumFromTo :: Int -> Int -> [Int]
def enumFromTo(m):
    return lambda n: list(range(m, 1 + n))


# justifyRight :: Int -> Char -> String -> String
def justifyRight(n):
    return lambda cFiller: lambda a: (
        ((n * cFiller) + str(a))[-n:]
    )


# unlines :: [String] -> String
def unlines(xs):
    return '\n'.join(xs)


main()
