'''Cantor set – strings as both model and display.'''

from itertools import (chain, islice)


# cantorLines :: Int -> String
def cantorLines(n):
    '''N levels of cantor segmentation,
       obtained and displayed in the
       form of lines of block characters.
    '''
    return '\n'.join(
        [''.join(x) for x in islice(
            iterate(cantor)(
                [3 ** (n - 1) * '█']
            ), n
        )]
    )


# cantor :: [String] -> [String]
def cantor(xs):
    '''A cantor line derived from its predecessor.'''
    def go(s):
        m = len(s) // 3
        blocks = s[0:m]
        return [
            blocks, m * ' ', blocks
        ] if '█' == s[0] else [s]
    return concatMap(go)(xs)


# MAIN ----------------------------------------------------
# main :: IO ()
def main():
    '''Testing cantor line generation to level 5'''

    print(
        cantorLines(5)
    )

# GENERIC -------------------------------------------------


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
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
    return lambda x: go(x)


# MAIN ---
if __name__ == '__main__':
    main()
