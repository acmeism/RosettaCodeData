'''Unique characters'''

from itertools import chain, groupby


# uniques :: [String] -> [Char]
def uniques(xs):
    '''Characters which occur only once
       across the given list of strings.
    '''
    return [
        h for h, (_, *tail) in
        groupby(sorted(chain(*xs)))
        if not tail
    ]


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Characters occurring only once
       across a list of 3 given strings.
    '''
    print(
        uniques([
            "133252abcdeeffd",
            "a6789798st",
            "yxcdfgxcyz"
        ])
    )


# MAIN ---
if __name__ == '__main__':
    main()
