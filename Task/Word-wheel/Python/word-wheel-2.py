'''Word wheel'''

from os.path import expanduser


# gridWords :: [String] -> [String] -> [String]
def gridWords(grid):
    '''The subset of words in ws which contain the
       central letter of the grid, and can be completed
       by single uses of some or all of the remaining
       letters in the grid.
    '''
    def go(ws):
        cs = ''.join(grid).lower()
        wheel = sorted(cs)
        wset = set(wheel)
        mid = cs[4]
        return [
            w for w in ws
            if 2 < len(w) and (mid in w) and (
                all(c in wset for c in w)
            ) and wheelFit(wheel, w)
        ]
    return go


# wheelFit :: String -> String -> Bool
def wheelFit(wheel, word):
    '''True if a given word can be constructed
       from (single uses of) some subset of
       the letters in the wheel.
    '''
    def go(ws, cs):
        return True if not cs else (
            False if not ws else (
                go(ws[1:], cs[1:]) if ws[0] == cs[0] else (
                    go(ws[1:], cs)
                )
            )
        )
    return go(wheel, sorted(word))


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Word wheel matches for a given grid in a copy of
       http://wiki.puzzlers.org/pub/wordlists/unixdict.txt
    '''
    print('\n'.join(
        gridWords(['NDE', 'OKG', 'ELW'])(
            readFile('~/unixdict.txt').splitlines()
        )
    ))


# ------------------------ GENERIC -------------------------

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
