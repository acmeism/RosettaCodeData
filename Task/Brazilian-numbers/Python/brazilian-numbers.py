'''Brazilian numbers'''

from itertools import count, islice


# isBrazil :: Int -> Bool
def isBrazil(n):
    '''True if n is a Brazilian number,
       in the sense of OEIS:A125134.
    '''
    return 7 <= n and (
        0 == n % 2 or any(
            map(monoDigit(n), range(2, n - 1))
        )
    )


# monoDigit :: Int -> Int -> Bool
def monoDigit(n):
    '''True if all the digits of n,
       in the given base, are the same.
    '''
    def go(base):
        def g(b, n):
            (q, d) = divmod(n, b)

            def p(qr):
                return d != qr[1] or 0 == qr[0]

            def f(qr):
                return divmod(qr[0], b)
            return d == until(p)(f)(
                (q, d)
            )[1]
        return g(base, n)
    return go


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''First 20 members each of:
        OEIS:A125134
        OEIS:A257521
        OEIS:A085104
    '''
    for kxs in ([
            (' ', count(1)),
            (' odd ', count(1, 2)),
            (' prime ', primes())
    ]):
        print(
            'First 20' + kxs[0] + 'Brazilians:\n' +
            showList(take(20)(filter(isBrazil, kxs[1]))) + '\n'
        )


# ------------------- GENERIC FUNCTIONS --------------------

# primes :: [Int]
def primes():
    ''' Non finite sequence of prime numbers.
    '''
    n = 2
    dct = {}
    while True:
        if n in dct:
            for p in dct[n]:
                dct.setdefault(n + p, []).append(p)
            del dct[n]
        else:
            yield n
            dct[n * n] = [n]
        n = 1 + n


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(str(x) for x in xs) + ']'


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
