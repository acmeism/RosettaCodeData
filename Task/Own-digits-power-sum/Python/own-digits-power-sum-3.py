'''Own digit power sums'''

from itertools import accumulate, chain, islice, repeat
from functools import reduce


# ownDigitsPowerSums :: Int -> [Int]
def ownDigitsPowerSums(n):
    '''All own digit power sums of digit length N'''
    def go(xs):
        m = reduce(lambda a, x: a + (x ** n), xs, 0)
        return [m] if digitsMatch(m)(xs) else []

    return concatMap(go)(
        combinationsWithRepetitions(n)(range(0, 1 + 9))
    )


# digitsMatch :: Int -> [Int] -> Bool
def digitsMatch(n):
    '''True if the digits in ds contain exactly
       the digits of n, in any order.
    '''
    def go(ds):
        return sorted(ds) == sorted(digits(n))
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Own digit power sums for digit lengths 3..9'''
    print(
        '\n'.join([
            'N ∈ [3 .. 8]',
            *map(str, concatMap(ownDigitsPowerSums)(
                range(3, 1 + 8)
            )),
            '\nN=9',
            *map(str, ownDigitsPowerSums(9))
        ])
    )


# ----------------------- GENERIC ------------------------

# combinationsWithRepetitions :: Int -> [a] -> [kTuple a]
def combinationsWithRepetitions(k):
    '''Combinations with repetitions.
       A list of tuples, representing
       sets of cardinality k,
       with elements drawn from xs.
    '''
    def f(a, x):
        def go(ys, xs):
            return xs + [[x] + y for y in ys]
        return accumulate(a, go)

    def combsBySize(xs):
        return [
            tuple(x) for x in next(islice(
                reduce(
                    f, xs, chain(
                        [[[]]],
                        islice(repeat([]), k)
                    )
                ), k, None
            ))
        ]
    return combsBySize


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been
       mapped.
       The list monad can be derived by using a function f
       which wraps its output in a list, (using an empty
       list to represent computational failure).
    '''
    def go(xs):
        return list(chain.from_iterable(map(f, xs)))
    return go


# digits :: Int -> [Int]
def digits(n):
    '''The individual digits of n as integers'''
    return [int(c) for c in str(n)]


# MAIN ---
if __name__ == '__main__':
    main()
