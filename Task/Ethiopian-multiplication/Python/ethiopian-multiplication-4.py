'''Ethiopian multiplication'''

from functools import reduce


# ethMult :: Int -> Int -> Int
def ethMult(n):
    '''Ethiopian multiplication of n by m.'''

    def doubled(x):
        return x + x

    def halved(h):
        qr = divmod(h, 2)
        if 0 < h:
            print('halve:', str(qr).rjust(8, ' '))
        return qr if 0 < h else None

    def addedWhereOdd(a, remx):
        odd, x = remx
        if odd:
            print(
                str(a).rjust(2, ' '), '+',
                str(x).rjust(3, ' '), '->',
                str(a + x).rjust(3, ' ')
            )
            return a + x
        else:
            print(str(x).rjust(8, ' '))
            return a

    return lambda m: reduce(
        addedWhereOdd,
        zip(
            unfoldr(halved)(n),
            iterate(doubled)(m)
        ),
        0
    )


# ------------------------- TEST -------------------------
def main():
    '''Tests of multiplication.'''

    print(
        '\nProduct:    ' + str(
            ethMult(17)(34)
        ),
        '\n_______________\n'
    )
    print(
        '\nProduct:    ' + str(
            ethMult(34)(17)
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


# showLog :: a -> IO String
def showLog(*s):
    '''Arguments printed with
       intercalated arrows.'''
    print(
        ' -> '.join(map(str, s))
    )


# unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
def unfoldr(f):
    '''Dual to reduce or foldr.
       Where catamorphism reduces a list to a summary value,
       the anamorphic unfoldr builds a list from a seed value.
       As long as f returns Just(a, b), a is prepended to the list,
       and the residual b is used as the argument for the next
       application of f.
       When f returns Nothing, the completed list is returned.'''
    def go(v):
        xr = v, v
        xs = []
        while True:
            xr = f(xr[0])
            if xr:
                xs.append(xr[1])
            else:
                return xs
        return xs
    return go


# MAIN ---
if __name__ == '__main__':
    main()
