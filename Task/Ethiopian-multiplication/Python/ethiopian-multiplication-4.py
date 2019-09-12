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
        return Just(qr) if 0 < h else Nothing()

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


# TEST -------------------------------------------------
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


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


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
    return lambda x: go(x)


# showLog :: a -> IO String
def showLog(*s):
    '''Arguments printed with
       intercalated arrows.'''
    print(
        ' -> '.join(map(str, s))
    )


# unfoldr(lambda x: Just((x, x - 1)) if 0 != x else Nothing())(10)
# -> [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]

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
            mb = f(xr[0])
            if mb.get('Nothing'):
                return xs
            else:
                xr = mb.get('Just')
                xs.append(xr[1])
        return xs
    return lambda x: go(x)


# MAIN ---
if __name__ == '__main__':
    main()
