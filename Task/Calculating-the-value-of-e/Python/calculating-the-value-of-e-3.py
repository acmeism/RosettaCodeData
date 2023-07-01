'''Calculating an approximate value for e'''

from itertools import (accumulate, chain)
from functools import (reduce)
from operator import (mul)


# eApprox :: () -> Float
def eApprox():
    '''Approximation to the value of e.'''
    return reduce(
        lambda a, x: a + 1 / x,
        scanl(mul)(1)(
            range(1, 18)
        ),
        0
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''

    print(
        eApprox()
    )


# GENERIC ABSTRACTIONS ------------------------------------

# scanl is like reduce, but returns a succession of
# intermediate values, building from the left.
# See, for example, under `scan` in the Lists chapter of
# the language-independent Bird & Wadler 1988.

# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but returns a succession of
       intermediate values, building from the left.'''
    return lambda a: lambda xs: (
        accumulate(chain([a], xs), f)
    )


# MAIN ---
if __name__ == '__main__':
    main()
