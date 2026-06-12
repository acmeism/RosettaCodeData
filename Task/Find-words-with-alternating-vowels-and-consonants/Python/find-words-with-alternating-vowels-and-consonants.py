'''Words with alternating vowels and consonants'''


# isLongAlternator :: String -> Bool
def isLongAlternator(s):
    '''True if s has 10 or more characters,
       and no two successive characters that are
       both vowels, or both consonants.
    '''
    def p(a, b):
        return isVowel(a) != isVowel(b)
    return 9 < len(s) and all(map(p, s, s[1:]))


def isVowel(c):
    '''True if c is in the set {a, e, i, o, u}
    '''
    return c in 'aeiou'


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Words without successive vowels or consonants
       found in the file 'unixdict.txt'
    '''
    matches = [
        x for x in readFile('unixdict.txt').splitlines()
        if isLongAlternator(x)
    ]
    w = max(len(x) for x in matches)
    print(str(len(matches)) + ' matching words:\n')
    print(
        '\n'.join(
            ' '.join(s) for s in chunksOf(4)([
                x.ljust(w, ' ') for x in matches
            ])
        )
    )


# ----------------------- GENERIC ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divible, the final list will be shorter than n.
    '''
    def go(xs):
        return (
            xs[i:n + i] for i in range(0, len(xs), n)
        ) if 0 < n else None
    return go


# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path.
    '''
    with open(fp, 'r', encoding='utf-8') as f:
        return f.read()


# MAIN ---
if __name__ == '__main__':
    main()
