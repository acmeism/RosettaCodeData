'''Generator-based permutations with repetition'''

from itertools import (chain, repeat)


# permsWithRepns :: [a] -> Int -> Generator [[a]]
def permsWithRepns(xs):
    '''Generator of permutations of length n, with
       elements drawn from the values in xs.
    '''
    def groupsOfSize(n):
        f = nthPermWithRepn(xs)(n)
        limit = len(xs)**n
        i = 0
        while i < limit:
            yield f(i)
            i = 1 + i
    return lambda n: groupsOfSize(n)


# Index as a 'number' in the base of the
# size of the set (of distinct values to be permuted),
# using each value as a 'digit'
# (leftmost value used as the 'zero')

# nthPermWithRepn :: [a] -> Int -> Int -> [a]
def nthPermWithRepn(xs):
    '''Indexed permutation of n values drawn from xs'''
    def go(intGroup, index):
        vs = list(xs)
        intBase = len(vs)
        intSet = intBase ** intGroup
        return (
            lambda ds=unfoldr(
                lambda v: (
                    lambda qr=divmod(v, intBase): Just(
                        (qr[0], vs[qr[1]])
                    )
                )() if 0 < v else Nothing()
            )(index): (
                list(repeat(vs[0], intGroup - len(ds))) + ds
            )
        )() if 0 < intBase and index < intSet else None
    return lambda intGroup: lambda index: go(
        intGroup, index
    )


# MAIN ----------------------------------------------------
# main :: IO ()
def main():
    '''Search for a 5 char permutation drawn from 'ACKR' matching "crack"'''

    cs = 'ACKR'
    wordLength = 5
    target = 'crack'

    gen = permsWithRepns(cs)(wordLength)
    mb = Nothing()
    for idx, xs in enumerate(gen):
        s = ''.join(xs)
        if target == s.lower():
            mb = Just((s, idx))
            break

    print(main.__doc__ + ':\n')
    print(
        maybe('No match found for "{k}"'.format(k=target))(
            lambda m: 'Permutation {idx} of {total}: {pm}'.format(
                idx=m[1], total=len(cs)**wordLength, pm=s
            )
        )(mb)
    )


# GENERIC FUNCTIONS -------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe(option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe(option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xs):
    '''The concatenation of all the elements
       in a list or iterable.'''

    def f(ys):
        zs = list(chain(*ys))
        return ''.join(zs) if isinstance(ys[0], str) else zs

    return (
        f(xs) if isinstance(xs, list) else (
            chain.from_iterable(xs)
        )
    ) if xs else []


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if None is m or m.get('Nothing') else (
        f(m.get('Just'))
    )


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


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
       When f returns Nothing, the completed list is returned.
    '''
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
