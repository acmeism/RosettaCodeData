'''Dictionary words twinned by (e -> i) replacement'''


# ieTwins :: String -> [(String, String)]
def ieTwins(s):
    '''Words in the lines of s which are twinned
       with other words in s by replacement of
       'e' by 'i'.
    '''
    longWords = [
        w for w in s.splitlines()
        if 5 < len(w)
    ]
    lexicon = {
        w for w in longWords
        if 'i' in w
    }

    return [
        (w, twin) for w in longWords
        if 'e' in w and (
            twin := w.replace('e', 'i')
        ) in lexicon
    ]


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Words twinned by ('e' -> 'i') replacement
       in unixdict.txt
    '''
    for pair in ieTwins(
        readFile("unixdict.txt")
    ):
        print(pair)


# ----------------------- GENERIC ------------------------

# readFile :: FilePath -> IO String
def readFile(fp):
    '''The contents of any file at the path fp.
    '''
    with open(fp, 'r', encoding='utf-8') as f:
        return f.read()


# MAIN ---
if __name__ == '__main__':
    main()
