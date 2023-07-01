# findIndexBinary_ :: (a -> Ordering) -> [a] -> Maybe Int
def findIndexBinary_(p):
    def go(xs):
        def bin(lo, hi):
            if hi < lo:
                return None
            else:
                mid = (lo + hi) // 2
                cmpr = p(xs[mid])
                return bin(lo, mid - 1) if -1 == cmpr else (
                    bin(mid + 1, hi) if 1 == cmpr else (
                        mid
                    )
                )
        n = len(xs)
        return bin(0, n - 1) if 0 < n else None
    return lambda xs: go(xs)


# COMPARISON CONSTRUCTORS ---------------------------------

# compare :: a -> a -> Ordering
def compare(a):
    '''Simple comparison of x and y -> LT|EQ|GT'''
    return lambda b: -1 if a < b else (1 if a > b else 0)


# byKV :: (a -> b) -> a -> a -> Ordering
def byKV(f):
    '''Property accessor function -> target value -> x -> LT|EQ|GT'''
    def go(v, x):
        fx = f(x)
        return -1 if v < fx else 1 if v > fx else 0
    return lambda v: lambda x: go(v, x)


# TESTS ---------------------------------------------------


if __name__ == '__main__':

    # BINARY SEARCH FOR WORD IN AZ-SORTED LIST

    mb1 = findIndexBinary_(compare('mu'))(
        # Sorted AZ
        ['alpha', 'beta', 'delta', 'epsilon', 'eta', 'gamma', 'iota',
         'kappa', 'lambda', 'mu', 'theta', 'zeta']
    )

    print (
        'Not found' if None is mb1 else (
            'Word found at index ' + str(mb1)
        )
    )

    # BINARY SEARCH FOR WORD OF GIVEN LENGTH (IN WORD-LENGTH SORTED LIST)

    mb2 = findIndexBinary_(byKV(len)(6))(
        # Sorted by rising length
        ['mu', 'eta', 'beta', 'iota', 'zeta', 'alpha', 'delta', 'gamma',
         'kappa', 'theta', 'lambda', 'epsilon']
    )

    print (
        'Not found' if None is mb2 else (
            'Word of given length found at index ' + str(mb2)
        )
    )
