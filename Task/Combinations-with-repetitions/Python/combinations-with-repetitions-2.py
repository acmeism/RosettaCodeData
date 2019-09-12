'''Combinations with repetitions'''

from itertools import (accumulate, chain, islice, repeat)
from functools import (reduce)


# combsWithRep :: Int -> [a] -> [kTuple a]
def combsWithRep(k):
    '''A list of tuples, representing
       sets of cardinality k,
       with elements drawn from xs.
    '''
    def f(a, x):
        def go(ys, xs):
            return xs + [[x] + y for y in ys]
        return accumulate(a, go)

    def combsBySize(xs):
        return reduce(
            f, xs, chain(
                [[[]]],
                islice(repeat([]), k)
            )
        )
    return lambda xs: [
        tuple(x) for x in next(islice(
            combsBySize(xs), k, None
        ))
    ]


# TEST ----------------------------------------------------
def main():
    '''Test the generation of sets of cardinality
       k with elements drawn from xs.
    '''
    print(
        combsWithRep(2)(['iced', 'jam', 'plain'])
    )
    print(
        len(combsWithRep(3)(enumFromTo(0)(9)))
    )


# GENERIC -------------------------------------------------

# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# showLog :: a -> IO String
def showLog(*s):
    '''Arguments printed with
       intercalated arrows.'''
    print(
        ' -> '.join(map(str, s))
    )


# MAIN ---
if __name__ == '__main__':
    main()
