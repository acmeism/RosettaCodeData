# deficientPerfectAbundantCountsUpTo :: Int -> (Int, Int, Int)
def deficientPerfectAbundantCountsUpTo(n):
    '''Counts of deficient, perfect, and abundant
       integers in the range [1..n].
    '''
    def go(dpa, x):
        divisorSum = sum(properDivisors(x))
        return nthArrow(succ)(dpa)(
            1 if x > divisorSum else (
                3 if x < divisorSum else 2
            )
        )
    return reduce(go, range(1, 1 + n), (0, 0, 0))
