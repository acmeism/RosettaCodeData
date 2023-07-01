'''Quotient and remainder of division by the Rhind papyrus method.'''

from functools import reduce


# eqyptianQuotRem :: Int -> Int -> (Int, Int)
def eqyptianQuotRem(m):
    '''Quotient and remainder derived by the Eqyptian method.'''

    def expansion(xi):
        '''Doubled value, and next power of two - both by self addition.'''
        x, i = xi
        return Nothing() if x > m else Just(
            ((x + x, i + i), xi)
        )

    def collapse(qr, ix):
        '''Addition of a power of two to the quotient,
           and subtraction of a paired value from the remainder.'''
        i, x = ix
        q, r = qr
        return (q + i, r - x) if x < r else qr

    return lambda n: reduce(
        collapse,
        unfoldl(expansion)(
            (1, n)
        ),
        (0, m)
    )


# ------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Test'''
    print(
        eqyptianQuotRem(580)(34)
    )


# ------------------- GENERIC FUNCTIONS -------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# unfoldl(lambda x: Just(((x - 1), x)) if 0 != x else Nothing())(10)
# -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
def unfoldl(f):
    '''Dual to reduce or foldl.
       Where these reduce a list to a summary value, unfoldl
       builds a list from a seed value.
       Where f returns Just(a, b), a is appended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns Nothing, the completed list is returned.
    '''
    def go(v):
        x, r = v, v
        xs = []
        while True:
            mb = f(x)
            if mb.get('Nothing'):
                return xs
            else:
                x, r = mb.get('Just')
                xs.insert(0, r)
        return xs
    return go


# MAIN ----------------------------------------------------
if __name__ == '__main__':
    main()
