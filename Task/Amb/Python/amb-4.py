from itertools import chain


# amb :: [a] -> (a -> [b]) -> [b]
def amb(xs):
    return lambda f: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# main :: IO ()
def main():

    xs = enumFromTo(1)(10)
    print ('Pythagorean triples from integers 1-10:')
    print (
        amb(xs)(
            lambda x: amb(xs)
            (lambda y: amb(xs)
                (lambda z: when(
                    x * x + y * y == z * z
                )(
                    (x, y, z)
                )
            ))
        )
    )

    # joins :: String -> String -> Bool
    def joins(a, b):
        return a[-1] == b[0]

    print ('\nRC problem given above:')
    print (
        amb(['the', 'that', 'a'])(
            lambda w1: amb(
                ['frog', 'elephant', 'thing']
            )(lambda w2: amb(
                ['walked', 'treaded', 'grows']
            )(lambda w3: amb(
                ['slowly', 'quickly']
            )(lambda w4: when(
                joins(w1, w2) and joins(w2, w3) and joins(w3, w4)
            )(
                (w1, w2, w3, w4)
            ))))
        )
    )
    print('\nAdditional problem reference in procedural version above:')
    print(
        amb([1, 2, 3])
        (
            lambda x: amb([4, 5, 6])
            (
                lambda y: when(x * y != 8)
                (
                    (x, y)
                )
            )
        )
    )

# GENERIC -------------------------------------------------


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    return lambda n: list(range(m, 1 + n))


# when :: Bool -> [a] -> [a]
def when(p):
    return lambda x: [x] if p else []

# MAIN ---
if __name__ == '__main__':
    main()
