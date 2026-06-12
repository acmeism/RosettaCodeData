'''Unique characters'''

from functools import reduce


# uniqueChars :: [String] -> [Char]
def uniqueChars(ws):
    '''Characters which occur only once
        across the given list of strings.
    '''
    def addedWord(dct, w):
        return reduce(updatedCharCount, w, dct)

    def updatedCharCount(a, c):
        return dict(
            a, **{
                c: 1 + a[c] if c in a else 1
            }
        )

    return sorted([
        k for k, v in reduce(addedWord, ws, {}).items()
        if 1 == v
    ])


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test'''
    print(
        uniqueChars([
            "133252abcdeeffd",
            "a6789798st",
            "yxcdfgxcyz"
        ])
    )


# MAIN ---
if __name__ == '__main__':
    main()
