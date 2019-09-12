'''Greatest subsequential sum'''

from functools import (reduce)


# maxSubseq :: [Int] -> [Int] -> (Int, [Int])
def maxSubseq(xs):
    '''Subsequence of xs with the maximum sum'''
    def go(ab, x):
        (m1, m2) = ab[0]
        hi = max((0, []), (m1 + x, m2 + [x]))
        return (hi, max(ab[1], hi))
    return reduce(go, xs, ((0, []), (0, [])))[1]


# TEST -----------------------------------------------------------
print(
    maxSubseq(
        [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
    )
)
