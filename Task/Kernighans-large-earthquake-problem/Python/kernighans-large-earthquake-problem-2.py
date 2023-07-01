from os.path import expanduser
from functools import (reduce)
from itertools import (chain)


# largeQuakes :: Int -> [String] -> [(String, String, String)]
def largeQuakes(n):
    def quake(threshold):
        def go(x):
            ws = x.split()
            return [tuple(ws)] if threshold < float(ws[2]) else []
        return lambda x: go(x)
    return concatMap(quake(n))


# main :: IO ()
def main():
    print (
        largeQuakes(6)(
            open(expanduser('~/data.txt')).read().splitlines()
        )
    )


# GENERIC ABSTRACTION -------------------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    return lambda xs: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
