'''Leonardo numbers'''

from functools import (reduce)
from itertools import (islice)


# leo :: Int -> Int -> Int -> Generator [Int]
def leo(L0, L1, delta):
    '''A number series of the
       Leonardo and Fibonacci pattern,
       where L0 and L1 are the first two terms,
       and delta = 1 for (L0, L1) == (1, 1)
       yields the Leonardo series, while
       delta = 0 defines the Fibonacci series.'''
    (x, y) = (L0, L1)
    while True:
        yield x
        (x, y) = (y, x + y + delta)


# main :: IO()
def main():
    '''Tests.'''

    print('\n'.join([
        'First 25 Leonardo numbers:',
        folded(16)(take(25)(
            leo(1, 1, 1)
        )),
        '',
        'First 25 Fibonacci numbers:',
        folded(16)(take(25)(
            leo(0, 1, 0)
        ))
    ]))


# FORMATTING ----------------------------------------------

# folded :: Int -> [a] -> String
def folded(n):
    '''Long list folded to rows of n terms each.'''
    return lambda xs: '[' + ('\n '.join(
        str(ns)[1:-1] for ns in chunksOf(n)(xs)
    ) + ']')


# GENERIC -------------------------------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n,
       subdividing the contents of xs.
       Where the length of xs is not evenly divible,
       the final list will be shorter than n.'''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


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
