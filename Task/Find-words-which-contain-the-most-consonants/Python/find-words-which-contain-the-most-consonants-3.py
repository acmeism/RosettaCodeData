'''Words using largest sets of consonants'''

from itertools import groupby
from os.path import expanduser
from string import ascii_letters


# uniqueGlyphCounts :: Set Char -> [String] -> [[(String, Int)]]
def uniqueGlyphCounts(glyphs):
    '''The words in a given list ordered and grouped by,
       the descending number of unique consonants which
       they contain, each word tupled with that number.
    '''
    def go(ws):
        return [
            list(snd(ab)) for ab in groupby(
                sorted(
                    [
                        (
                            w,
                            len(set(w).intersection(glyphs))
                        )
                        for w in ws
                    ],
                    key=snd,
                    reverse=True
                ),
                key=snd
            )
        ]

    return go


# noGlyphRepeated :: Set Char -> (String, Int) -> Bool
def noGlyphRepeated(glyphs):
    '''True if the string in a given (String, Int)
       tuple contains no multiple uses of any of
       the given set of glyphs.
    '''
    def go(sn):
        s, n = sn
        return n == len([c for c in s if c in glyphs])

    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Words drawn from a given list which use the largest
       set of consonants, and contain no repeated consonants.
    '''

    consonants = set(ascii_letters).difference(
        set("AEIOUaeiou")
    )

    largestConsonantSet = uniqueGlyphCounts(consonants)(
        readFile("unixdict.txt").splitlines()
    )[0]

    noConsonantsReused = noGlyphRepeated(consonants)

    print("Words using largest sets of unique consonants:")
    for x in largestConsonantSet:
        print(x)

    print("\nExcluding words which reuse any consonants:")
    for sn in largestConsonantSet:
        if noConsonantsReused(sn):
            print(sn)


# ----------------------- GENERIC ------------------------

# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path
       derived by expanding any ~ in fp.
    '''
    with open(expanduser(fp), 'r', encoding='utf-8') as f:
        return f.read()


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# MAIN ---
if __name__ == '__main__':
    main()
