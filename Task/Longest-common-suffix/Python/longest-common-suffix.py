'''Longest common suffix'''

from itertools import takewhile
from functools import reduce


# longestCommonSuffix :: [String] -> String
def longestCommonSuffix(xs):
    '''Longest suffix shared by all
       strings in xs.
    '''
    def allSame(cs):
        h = cs[0]
        return all(h == c for c in cs[1:])

    def firstCharPrepended(s, cs):
        return cs[0] + s
    return reduce(
        firstCharPrepended,
        takewhile(
            allSame,
            zip(*(reversed(x) for x in xs))
        ),
        ''
    )


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Test'''

    samples = [
        [
            "Sunday", "Monday", "Tuesday", "Wednesday",
            "Thursday", "Friday", "Saturday"
        ], [
            "Sondag", "Maandag", "Dinsdag", "Woensdag",
            "Donderdag", "Vrydag", "Saterdag"
        ]
    ]
    for xs in samples:
        print(
            longestCommonSuffix(xs)
        )


# MAIN ---
if __name__ == '__main__':
    main()
