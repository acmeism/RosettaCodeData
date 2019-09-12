'''Largest anagram groups found in list of words.'''

from os.path import expanduser
from itertools import groupby
from operator import eq


# main :: IO ()
def main():
    '''Largest anagram groups in local unixdict.txt'''

    print(unlines(
        largestAnagramGroups(
            lines(readFile('unixdict.txt'))
        )
    ))


# largestAnagramGroups :: [String] -> [[String]]
def largestAnagramGroups(ws):
    '''A list of the anagram groups of
       of the largest size found in a
       given list of words.
    '''

    # wordChars :: String -> (String, String)
    def wordChars(w):
        '''A word paired with its
           AZ sorted characters
        '''
        return (''.join(sorted(w)), w)

    groups = list(map(
        compose(list)(snd),
        groupby(
            sorted(
                map(wordChars, ws),
                key=fst
            ),
            key=fst
        )
    ))

    intMax = max(map(len, groups))
    return list(map(
        compose(unwords)(curry(map)(snd)),
        filter(compose(curry(eq)(intMax))(len), groups)
    ))


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    return lambda a: lambda b: f(a, b)


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# lines :: String -> [String]
def lines(s):
    '''A list of strings,
       (containing no newline characters)
       derived from a single new-line delimited string.'''
    return s.splitlines()


# from os.path import expanduser
# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path
       derived by expanding any ~ in fp.'''
    with open(expanduser(fp), 'r', encoding='utf-8') as f:
        return f.read()


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# unwords :: [String] -> String
def unwords(xs):
    '''A space-separated string derived from
       a list of words.'''
    return ' '.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
