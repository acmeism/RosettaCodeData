'''Sum of the digits of n is substring of n'''

from functools import reduce
from itertools import chain


# digitSumIsSubString :: String -> Bool
def digitSumIsSubString(s):
    '''True if the sum of the decimal digits in s
       matches any contiguous substring of s.
    '''
    return str(
        reduce(lambda a, c: a + int(c), s, 0)
    ) in s


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Matches in [0..999]'''
    print(
        showMatches(
            digitSumIsSubString
        )(999)
    )


# ----------------------- DISPLAY ------------------------

# showMatches :: (String -> Bool) -> Int -> String
def showMatches(p):
    '''A listing of the integer strings [0..limit]
       which match the predicate p.
    '''
    def go(limit):
        def triage(n):
            s = str(n)
            return [s] if p(s) else []

        xs = list(
            chain.from_iterable(
                map(triage, range(0, 1 + limit))
            )
        )
        w = len(xs[-1])
        return f'{len(xs)} matches < {limit}:\n' + (
            '\n'.join(
                ' '.join(cell.rjust(w, ' ') for cell in row)
                for row in chunksOf(10)(xs)
            )
        )

    return go


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


# MAIN ---
if __name__ == '__main__':
    main()
