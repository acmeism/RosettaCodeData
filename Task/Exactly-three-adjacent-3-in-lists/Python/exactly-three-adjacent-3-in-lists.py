'''N instances of N and all contiguous'''

from itertools import dropwhile, takewhile


# nnPeers :: Int -> [Int] -> Bool
def nnPeers(n):
    '''True if xs contains exactly n instances of n
       and all instances are contiguous.
    '''
    def p(x):
        return n == x

    def go(xs):
        fromFirstMatch = list(dropwhile(
            lambda v: not p(v),
            xs
        ))
        ns = list(takewhile(p, fromFirstMatch))
        rest = fromFirstMatch[len(ns):]

        return p(len(ns)) and (
            not any(p(x) for x in rest)
        )

    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Tests for N=3'''
    print(
        '\n'.join([
            f'{xs} -> {nnPeers(3)(xs)}' for xs in [
                [9, 3, 3, 3, 2, 1, 7, 8, 5],
                [5, 2, 9, 3, 3, 7, 8, 4, 1],
                [1, 4, 3, 6, 7, 3, 8, 3, 2],
                [1, 2, 3, 4, 5, 6, 7, 8, 9],
                [4, 6, 8, 7, 2, 3, 3, 3, 1]
            ]
        ])
    )


# MAIN ---
if __name__ == '__main__':
    main()
