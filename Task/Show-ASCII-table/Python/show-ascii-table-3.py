'''Plain text ASCII code table'''

from functools import reduce
from itertools import chain


# asciiTable :: String
def asciiTable():
    '''Table of ASCII codes arranged in 16 rows * 6 columns.'''
    return unlines(
        concat(c.ljust(12, ' ') for c in xs) for xs in (
            transpose(chunksOf(16)(
                [asciiEntry(n) for n in enumFromTo(32)(127)]
            ))
        )
    )


# asciiEntry :: Int -> String
def asciiEntry(n):
    '''Number, and name or character, for given point in ASCII code.'''
    k = asciiName(n)
    return k if '' == k else (
        concat([str(n).rjust(3, ' '), ' : ', k])
    )


# asciiName :: Int -> String
def asciiName(n):
    '''Name or character for given ASCII code.'''
    return '' if 32 > n or 127 < n else (
        'Spc' if 32 == n else (
            'Del' if 127 == n else chr(n)
        )
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''
    print(
        asciiTable()
    )


# GENERIC ABSTRACTIONS ------------------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n,
       subdividing the contents of xs.
       Where the length of xs is not evenly divible
       the final list will be shorter than n.'''
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xxs):
    '''The concatenation of all the elements in a list.'''
    xs = list(chain.from_iterable(xxs))
    unit = '' if isinstance(xs, str) else []
    return unit if not xs else (
        ''.join(xs) if isinstance(xs[0], str) else xs
    )


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# splitAt :: Int -> [a] -> ([a], [a])
def splitAt(n):
    '''A tuple pairing the prefix of length n
       with the rest of xs.'''
    return lambda xs: (xs[0:n], xs[n:])


# transpose :: Matrix a -> Matrix a
def transpose(m):
    '''The rows and columns of the argument transposed.
       (The matrix containers and rows can be lists or tuples).'''
    if m:
        inner = type(m[0])
        z = zip(*m)
        return (type(m))(
            map(inner, z) if tuple != inner else z
        )
    else:
        return m


# unlines :: [String] -> String
def unlines(xs):
    '''A single newline-delimited string derived
       from a list of strings.'''
    return '\n'.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
