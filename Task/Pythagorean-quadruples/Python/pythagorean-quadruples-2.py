'''Pythagorean Quadruples'''

from itertools import islice, takewhile


# unrepresentables :: () -> [Int]
def unrepresentables():
    '''A non-finite stream of powers of two which can
       not be represented as a Pythagorean quadruple.
    '''
    return merge(
        powersOfTwo()
    )(
        5 * x for x in powersOfTwo()
    )


# powersOfTwo :: Gen [Int]
def powersOfTwo():
    '''A non-finite stream of successive powers of two.
    '''
    def double(x):
        return 2 * x

    return iterate(double)(1)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''For positive integers up to 2,200 (inclusive)
    '''
    def p(x):
        return 2200 >= x

    print(
        list(
            takewhile(p, unrepresentables())
        )
    )


# ----------------------- GENERIC ------------------------

# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated
       applications of f to x.
    '''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return go


# merge :: Gen [Int] -> Gen [Int] -> Gen [Int]
def merge(ga):
    '''An ordered stream of values drawn from two
       other ordered streams.
    '''
    def go(gb):
        def f(ma, mb):
            a, b = ma, mb
            while a and b:
                ta, tb = a, b
                if ta[0] < tb[0]:
                    yield ta[0]
                    a = uncons(ta[1])
                else:
                    yield tb[0]
                    b = uncons(tb[1])
        return f(uncons(ga), uncons(gb))
    return go


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    def go(xs):
        return (
            xs[0:n]
            if isinstance(xs, (list, tuple))
            else list(islice(xs, n))
        )
    return go


# uncons :: [a] -> Maybe (a, [a])
def uncons(xs):
    '''The deconstruction of a non-empty list
       (or generator stream) into two parts:
       a head value, and the remaining values.
    '''
    if isinstance(xs, list):
        return (xs[0], xs[1:]) if xs else None
    else:
        nxt = take(1)(xs)
        return (nxt[0], xs) if nxt else None


# MAIN ---
if __name__ == '__main__':
    main()
