'''Forward difference'''


from itertools import islice
from operator import sub


# forwardDifference :: Num a => [a] -> [a]
def forwardDifference(xs):
    '''1st order forward difference of xs.
    '''
    return [sub(*x) for x in zip(xs[1:], xs)]


# nthForwardDifference :: Num a => [a] -> Int -> [a]
def nthForwardDifference(xs):
    '''Nth order forward difference of xs.
    '''
    return index(iterate(forwardDifference)(xs))


# ------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Nth order forward difference.'''

    xs = [90, 47, 58, 29, 22, 32, 55, 5, 55, 73]

    print('9th order forward difference of:')
    print(xs)
    print('')
    print(
        ' -> ' + repr(nthForwardDifference(xs)(9))
    )

    print('\nSuccessive orders of forward difference:')
    print(unlines([
        str(i) + ' -> ' + repr(x) for i, x in
        enumerate(take(10)(
            iterate(forwardDifference)(xs)
        ))
    ]))


# ------------------- GENERIC FUNCTIONS -------------------

# index (!!) :: [a] -> Int -> a
def index(xs):
    '''Item at given (zero-based) index.'''
    return lambda n: None if 0 > n else (
        xs[n] if (
            hasattr(xs, "__getitem__")
        ) else next(islice(xs, n, None))
    )


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated
       applications of f to x.
    '''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return go


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
    )


# unlines :: [String] -> String
def unlines(xs):
    '''A single string formed by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
