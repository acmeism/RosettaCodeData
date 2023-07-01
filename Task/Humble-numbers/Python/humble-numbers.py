'''Humble numbers'''

from itertools import groupby, islice
from functools import reduce


# humbles :: () -> [Int]
def humbles():
    '''A non-finite stream of Humble numbers.
       OEIS A002473
    '''
    hs = set([1])
    while True:
        nxt = min(hs)
        yield nxt
        hs.remove(nxt)
        hs.update(nxt * x for x in [2, 3, 5, 7])


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''First 50, and counts with N digits'''

    print('First 50 Humble numbers:\n')
    for row in chunksOf(10)(
            take(50)(humbles())
    ):
        print(' '.join(map(
            lambda x: str(x).rjust(3),
            row
        )))

    print('\nCounts of Humble numbers with n digits:\n')
    for tpl in take(10)(
            (k, len(list(g))) for k, g in
            groupby(len(str(x)) for x in humbles())
    ):
        print(tpl)


# GENERIC -------------------------------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        list(islice(xs, n))
    )


# MAIN ---
if __name__ == '__main__':
    main()
