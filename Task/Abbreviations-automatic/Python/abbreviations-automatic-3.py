'''Automatic abbreviations'''

from itertools import (accumulate, chain)
from os.path import expanduser


# abbrevLen :: [String] -> Int
def abbrevLen(xs):
    '''The minimum length of prefix required to obtain
       a unique abbreviation for each string in xs.'''
    n = len(xs)

    return next(
        len(a[0]) for a in map(
            compose(nub)(map_(concat)),
            transpose(list(map(inits, xs)))
        ) if n == len(a)
    )


# TEST ----------------------------------------------------
def main():
    '''Test'''

    xs = map_(strip)(
        lines(readFile('weekDayNames.txt'))
    )
    for i, n in enumerate(map(compose(abbrevLen)(words), xs)):
        print(n, '  ', xs[i])


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Function composition.'''
    return lambda f: lambda x: g(f(x))


# concat :: [String] -> String
def concat(xs):
    '''The concatenation of a list of strings.'''
    return ''.join(xs)


# inits :: [a] -> [[a]]
def inits(xs):
    '''all initial segments of xs, shortest first.'''
    return list(scanl(lambda a, x: a + [x])(
        []
    )(list(xs)))


# lines :: String -> [String]
def lines(s):
    '''A list of strings,
       (containing no newline characters)
       derived from a single new-line delimited string.'''
    return s.splitlines()


# map :: (a -> b) -> [a] -> [b]
def map_(f):
    '''The list obtained by applying f
       to each element of xs.'''
    return lambda xs: list(map(f, xs))


# nub :: [a] -> [a]
def nub(xs):
    '''A list containing the same elements as xs,
       without duplicates, in the order of their
       first occurrence.'''
    return list(dict.fromkeys(xs))


# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path
       derived by expanding any ~ in fp.'''
    with open(expanduser(fp), 'r', encoding='utf-8') as f:
        return f.read()


# scanl :: (b -> a -> b) -> b -> [a] -> [b]
def scanl(f):
    '''scanl is like reduce, but returns a succession of
       intermediate values, building from the left.'''
    return lambda a: lambda xs: (
        accumulate(chain([a], xs), f)
    )


# strip :: String -> String
def strip(s):
    '''A copy of s without any leading or trailling
       white space.'''
    return s.strip()


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


# words :: String -> [String]
def words(s):
    '''A list of words delimited by characters
       representing white space.'''
    return s.split()


# MAIN ---
if __name__ == '__main__':
    main()
