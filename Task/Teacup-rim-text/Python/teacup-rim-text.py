'''Teacup rim text'''

from itertools import chain, groupby
from os.path import expanduser
from functools import reduce


# main :: IO ()
def main():
    '''Circular anagram groups, of more than one word,
       and containing words of length > 2, found in:
       https://www.mit.edu/~ecprice/wordlist.10000
    '''
    print('\n'.join(
        concatMap(circularGroup)(
            anagrams(3)(
                # Reading from a local copy.
                lines(readFile('~/mitWords.txt'))
            )
        )
    ))


# anagrams :: Int -> [String] -> [[String]]
def anagrams(n):
    '''Groups of anagrams, of minimum group size n,
       found in the given word list.
    '''
    def go(ws):
        def f(xs):
            return [
                [snd(x) for x in xs]
            ] if n <= len(xs) >= len(xs[0][0]) else []
        return concatMap(f)(groupBy(fst)(sorted(
            [(''.join(sorted(w)), w) for w in ws],
            key=fst
        )))
    return go


# circularGroup :: [String] -> [String]
def circularGroup(ws):
    '''Either an empty list, or a list containing
       a string showing any circular subset found in ws.
    '''
    lex = set(ws)
    iLast = len(ws) - 1
    # If the set contains one word that is circular,
    # then it must contain all of them.
    (i, blnCircular) = until(
        lambda tpl: tpl[1] or (tpl[0] > iLast)
    )(
        lambda tpl: (1 + tpl[0], isCircular(lex)(ws[tpl[0]]))
    )(
        (0, False)
    )
    return [' -> '.join(allRotations(ws[i]))] if blnCircular else []


# isCircular :: Set String -> String -> Bool
def isCircular(lexicon):
    '''True if all of a word's rotations
       are found in the given lexicon.
    '''
    def go(w):
        def f(tpl):
            (i, _, x) = tpl
            return (1 + i, x in lexicon, rotated(x))

        iLast = len(w) - 1
        return until(
            lambda tpl: iLast < tpl[0] or (not tpl[1])
        )(f)(
            (0, True, rotated(w))
        )[1]
    return go


# allRotations :: String -> [String]
def allRotations(w):
    '''All rotations of the string w.'''
    return takeIterate(len(w) - 1)(
        rotated
    )(w)


# GENERIC -------------------------------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# groupBy :: (a -> b) -> [a] -> [[a]]
def groupBy(f):
    '''The elements of xs grouped,
       preserving order, by equality
       in terms of the key function f.
    '''
    def go(xs):
        return [
            list(x[1]) for x in groupby(xs, key=f)
        ]
    return go


# lines :: String -> [String]
def lines(s):
    '''A list of strings,
       (containing no newline characters)
       derived from a single new-line delimited string.
    '''
    return s.splitlines()


# mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
def mapAccumL(f):
    '''A tuple of an accumulation and a list derived by a
       combined map and fold,
       with accumulation from left to right.
    '''
    def go(a, x):
        tpl = f(a[0], x)
        return (tpl[0], a[1] + [tpl[1]])
    return lambda acc: lambda xs: (
        reduce(go, xs, (acc, []))
    )


# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path
       derived by expanding any ~ in fp.
    '''
    with open(expanduser(fp), 'r', encoding='utf-8') as f:
        return f.read()


# rotated :: String -> String
def rotated(s):
    '''A string rotated 1 character to the right.'''
    return s[1:] + s[0]


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# takeIterate :: Int -> (a -> a) -> a -> [a]
def takeIterate(n):
    '''Each value of n iterations of f
       over a start value of x.
    '''
    def go(f):
        def g(x):
            def h(a, i):
                v = f(a) if i else x
                return (v, v)
            return mapAccumL(h)(x)(
                range(0, 1 + n)
            )[1]
        return g
    return go


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f):
        def g(x):
            v = x
            while not p(v):
                v = f(v)
            return v
        return g
    return go


# MAIN ---
if __name__ == '__main__':
    main()
