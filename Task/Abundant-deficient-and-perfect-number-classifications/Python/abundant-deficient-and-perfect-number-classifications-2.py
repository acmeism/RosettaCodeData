'''Abundant, deficient and perfect number classifications'''

from itertools import accumulate, chain, groupby, product
from functools import reduce
from math import floor, sqrt
from operator import mul


# deficientPerfectAbundantCountsUpTo :: Int -> (Int, Int, Int)
def deficientPerfectAbundantCountsUpTo(n):
    '''Counts of deficient, perfect, and abundant
       integers in the range [1..n].
    '''
    def go(dpa, x):
        deficient, perfect, abundant = dpa
        divisorSum = sum(properDivisors(x))
        return (
            succ(deficient), perfect, abundant
        ) if x > divisorSum else (
            deficient, perfect, succ(abundant)
        ) if x < divisorSum else (
            deficient, succ(perfect), abundant
        )
    return reduce(go, range(1, 1 + n), (0, 0, 0))


# --------------------------TEST--------------------------
# main :: IO ()
def main():
    '''Size of each sub-class of integers drawn from [1..20000]:'''

    print(main.__doc__)
    print(
        '\n'.join(map(
            lambda a, b: a.rjust(10) + ' -> ' + str(b),
            ['Deficient', 'Perfect', 'Abundant'],
            deficientPerfectAbundantCountsUpTo(20000)
        ))
    )


# ------------------------GENERIC-------------------------

# primeFactors :: Int -> [Int]
def primeFactors(n):
    '''A list of the prime factors of n.
    '''
    def f(qr):
        r = qr[1]
        return step(r), 1 + r

    def step(x):
        return 1 + (x << 2) - ((x >> 1) << 1)

    def go(x):
        root = floor(sqrt(x))

        def p(qr):
            q = qr[0]
            return root < q or 0 == (x % q)

        q = until(p)(f)(
            (2 if 0 == x % 2 else 3, 1)
        )[0]
        return [x] if q > root else [q] + go(x // q)

    return go(n)


# properDivisors :: Int -> [Int]
def properDivisors(n):
    '''The ordered divisors of n, excluding n itself.
    '''
    def go(a, x):
        return [a * b for a, b in product(
            a,
            accumulate(chain([1], x), mul)
        )]
    return sorted(
        reduce(go, [
            list(g) for _, g in groupby(primeFactors(n))
        ], [1])
    )[:-1] if 1 < n else []


# succ :: Int -> Int
def succ(x):
    '''The successor of a value.
       For numeric types, (1 +).
    '''
    return 1 + x


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


# MAIN ---
if __name__ == '__main__':
    main()
