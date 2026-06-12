'''Odd words'''

from os.path import expanduser
from json import dumps


# oddPairs :: Int -> [String] -> Dict
def oddPairs(minLength):
    '''A dictionary of (word::oddWord) pairs
       in which the words are drawn from a given wordList,
       and the oddWords have at least a minimum length.
    '''
    def go(wordList):
        lexicon = set(wordList)
        return {
            k: v for k, v in ((w, w[::2]) for w in wordList)
            if minLength <= len(v) and v in lexicon
        }
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Odd words of 5 or more characters, paired with their
       sources, which are drawn from a local unixdict.txt
    '''
    print(dumps(
        oddPairs(5)(
            readFile('~/unixdict.txt').split('\n')
        ),
        indent=4
    ))


# ----------------------- GENERIC ------------------------

# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path
       derived by expanding any ~ in fp.
    '''
    with open(expanduser(fp), 'r', encoding='utf-8') as f:
        return f.read()


# MAIN ---
if __name__ == '__main__':
    main()
