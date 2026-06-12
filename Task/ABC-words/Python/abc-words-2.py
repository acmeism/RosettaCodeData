'''ABC Words'''


# isABC :: String -> Bool
def isABC(s):
    '''True if s contains 'a', 'b' and 'c', with the
       first occurrences of each in that order.
    '''
    return bind(
        bind(
            residue('bc', 'a')(s)
        )(
            residue('c', 'b')
        )
    )(
        lambda r: 'c' in r
    )


# residue (String, Char) -> String -> Maybe String
def residue(disallowed, c):
    '''Any characters remaining in s after c, unless
       c is preceded by excluded characters.
    '''
    def go(s):
        if s:
            x = s[0]
            return None if x in disallowed else (
                s[1:] if c == x else go(s[1:])
            )
        else:
            return None
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''All words matching the isABC predicate
       in a local copy of unixdict.txt
    '''
    for x in enumerate(
        filter(
            isABC,
            readFile('unixdict.txt').splitlines()
        ),
        start=1
    ):
        print(x)


# ----------------------- GENERIC ------------------------

# bind (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
def bind(m):
    '''Composition of a sequence of (a -> None | b) functions.
       If m is None, it is passed straight through.
       If m is x, the result is an application
       of the (a -> None | b) function (mf) to x.
    '''
    def go(mf):
        return m if None is m else mf(m)
    return go


# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path
       derived by expanding any ~ in fp.
    '''
    with open(fp, 'r', encoding='utf-8') as f:
        return f.read()


# MAIN ---
if __name__ == '__main__':
    main()
