import re


# sparkLine :: [Float] -> [String]
def sparkLine(xs):
    def go(xs):
        ys = sorted(xs)
        mn, mx = ys[0], ys[-1]
        n = len(xs)
        mid = n // 2
        w = (mx - mn) / 8
        lbounds = list(map(lambda i: mn + (w * i), range(1, 8)))
        return [
            ''.join(map(
                lambda x: maybe('█')(
                    lambda i: '▁▂▃▄▅▆▇'[i]
                )(findIndex(lambda b: b > x)(lbounds)),
                xs
            )),
            ' '.join(map(str, xs)),
            '\t'.join([
                'Min ' + str(mn),
                'Mean ' + str(round(mean(xs), 2)),
                'Median ' + str(
                    (ys[mid - 1] + ys[mid]) / 2 if even(n) else (
                        ys[mid]
                    )
                ),
                'Max ' + str(mx)
            ]),
            ''
        ]
    return go(xs) if xs else []


# main :: IO ()
def main():
    print(
        unlines(map(
            compose(compose(unlines)(sparkLine))(readFloats),
            [
                "0, 1, 19, 20",
                "0, 999, 4000, 4999, 7000, 7999",
                "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1",
                "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"
            ]
        ))
    )


# GENERIC -------------------------------------------------


# Just :: a -> Maybe a
def Just(x):
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    return {'type': 'Maybe', 'Nothing': True}


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    return lambda f: lambda x: g(f(x))


# even :: Int -> Bool
def even(x):
    return 0 == x % 2


# findIndex :: (a -> Bool) -> [a] -> Maybe Int
def findIndex(p):
    def go(xs):
        try:
            return Just(next(
                i for i, v in enumerate(xs) if p(v)
            ))
        except StopIteration:
            return Nothing()
    return lambda xs: go(xs)


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    return lambda f: lambda m: v if m.get('Nothing') else (
        f(m.get('Just'))
    )


# mean :: [Num] -> Float
def mean(xs):
    return sum(xs) / float(len(xs))


# readFloats :: String -> [Float]
def readFloats(s):
    return list(map(
        float,
        re.split('[\s,]+', s)
    ))


# unlines :: [String] -> String
def unlines(xs):
    return '\n'.join(xs)


# TEST -------------------------------------------------
if __name__ == '__main__':
    main()
