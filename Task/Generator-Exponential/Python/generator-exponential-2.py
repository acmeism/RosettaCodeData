'''Exponentials as generators'''

from itertools import count, islice


# powers :: Gen [Int]
def powers(n):
    '''A non-finite succession of integers,
       starting at zero,
       raised to the nth power.'''

    def f(x):
        return pow(x, n)

    return map(f, count(0))


# main :: IO ()
def main():
    '''Taking the difference between two derived generators.'''
    print(
        take(10)(
            drop(20)(
                differenceGen(powers(2))(
                    powers(3)
                )
            )
        )
    )


# GENERIC -------------------------------------------------


# differenceGen :: Gen [a] -> Gen [a] -> Gen [a]
def differenceGen(ga):
    '''All values of ga except any
       already seen in gb.'''
    def go(a, b):
        stream = zip(a, b)
        bs = set([])
        while True:
            xy = next(stream, None)
            if None is not xy:
                x, y = xy
                bs.add(y)
                if x not in bs:
                    yield x
            else:
                return
    return lambda gb: go(ga, gb)


# drop :: Int -> [a] -> [a]
# drop :: Int -> String -> String
def drop(n):
    '''The sublist of xs beginning at
       (zero-based) index n.'''
    def go(xs):
        if isinstance(xs, list):
            return xs[n:]
        else:
            take(n)(xs)
            return xs
    return lambda xs: go(xs)


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.'''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else list(islice(xs, n))
    )


# MAIN ---
if __name__ == '__main__':
    main()
