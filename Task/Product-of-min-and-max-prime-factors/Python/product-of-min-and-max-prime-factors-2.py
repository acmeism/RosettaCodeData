'''Produce of min and max prime factors'''

from itertools import chain, count, islice
from math import floor, sqrt


# oeisA066048 :: [Int]
def oeisA066048():
    '''Infinite series of terms in OEIS A066048.
    '''
    def f(x):
        ns = primeFactors(x)
        return ns[0] * ns[-1]

    return chain([1], map(f, count(2)))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First 100 terms in OEIS A066048.
    '''
    print(table(10)(
        list(map(
            str, islice(
                oeisA066048(),
                100
            )
        ))
    ))


# ----------------------- GENERIC ------------------------

# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    '''A series of lists of length n, subdividing the
       contents of xs. Where the length of xs is not evenly
       divisible, the final list will be shorter than n.
    '''
    def go(xs):
        return (
            xs[i:n + i] for i in range(0, len(xs), n)
        ) if 0 < n else None
    return go


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


# table :: Int -> [String] -> String
def table(n):
    '''A list of strings formatted as
       right-justified rows of n columns.
    '''
    def go(xs):
        w = len(max(xs, key=len))
        return '\n'.join(
            ' '.join(row) for row in chunksOf(n)([
                s.rjust(w, ' ') for s in xs
            ])
        )
    return go


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f):
        def g(x):
            v = x
            while not p(v):
                v = f(v)
            return v
        return g
    return go


# MAIN ---
if __name__ == '__main__':
    main()
