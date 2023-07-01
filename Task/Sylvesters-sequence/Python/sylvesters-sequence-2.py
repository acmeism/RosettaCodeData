'''Sylvester's sequence'''

from functools import reduce
from itertools import islice

# sylvester :: [Int]
def sylvester():
    '''A non finite sequence of the terms of OEIS A000058
    '''
    return iterate(
        lambda x: x * (x - 1) + 1
    )(2)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First terms, and sum of reciprocals.'''

    print("First 10 terms of OEIS A000058:")
    xs = list(islice(sylvester(), 10))
    print('\n'.join([
        str(x) for x in xs
    ]))

    print("\nSum of the reciprocals of the first 10 terms:")
    print(
        reduce(lambda a, x: a + 1 / x, xs, 0)
    )

# ----------------------- GENERIC ------------------------

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


# MAIN ---
if __name__ == '__main__':
    main()
