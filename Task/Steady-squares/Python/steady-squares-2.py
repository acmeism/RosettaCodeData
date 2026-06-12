'''Steady squares'''

from itertools import chain


# steadyPair :: Int -> [(String, String)]
def steadyPair(x):
    '''An empty list if x^2 is not suffixed, in decimal,
       by the decimal digits of x. Otherwise a list
       containing a tuple of the decimal strings of (x, x^2)
    '''
    s, s2 = str(x), str(x**2)

    return [(s, s2)] if s2.endswith(s) else []


# ------------------------ TESTS -------------------------
# main :: IO ()
def main():
    '''Roots of numbers with steady squares up to 10000
    '''
    ns = range(1, 1 + 10000)
    xs = concatMap(steadyPair)(ns)
    w, w2 = (len(x) for x in xs[-1])

    print([n for n in ns if steadyPair(n)])
    print()
    print(
        '\n'.join([
            f'{s.rjust(w, " ")} -> {s2.rjust(w2, " ")}'
            for (s, s2) in xs
        ])
    )


# ----------------------- GENERIC ------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been
       mapped.
       The list monad can be derived by using a function f
       which wraps its output in a list, (using an empty
       list to represent computational failure).
    '''
    def go(xs):
        return list(chain.from_iterable(map(f, xs)))
    return go


# MAIN ---
if __name__ == '__main__':
    main()
