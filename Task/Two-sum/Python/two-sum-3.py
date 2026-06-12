'''Finding two integers that sum to a target value.'''

from itertools import chain


# sumTwo :: Int -> [Int] -> [(Int, Int)]
def sumTwo(n, xs):
    '''All the pairs of integers in xs which
       sum to n.
    '''
    def go(vs):
        return [vs[0]] if n == sum(vs[1]) else []
    ixs = list(enumerate(xs))
    return list(
        bind(ixs)(
            lambda ix: bind(ixs[ix[0]:])(
                lambda jy: go(tuple(zip(*(ix, jy))))
            )
        )
    )


# TEST ----------------------------------------------------

# main :: IO ()
def main():
    '''Tests'''

    for n in [21, 25]:
        print(
            sumTwo(n, [0, 2, 11, 19, 90, 10])
        )


# GENERIC -------------------------------------------------

# bind (>>=) :: [a] -> (a -> [b]) -> [b]
def bind(xs):
    '''List monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.
    '''
    return lambda f: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


if __name__ == '__main__':
    main()
