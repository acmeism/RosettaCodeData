'''Van Eck sequence'''

from functools import reduce
from itertools import repeat


# vanEck :: Int -> [Int]
def vanEck(n):
    '''First n terms of the van Eck sequence.'''

    return churchNumeral(n)(
        lambda xs: cons(
            maybe(0)(succ)(
                elemIndex(xs[0])(xs[1:])
            )
        )(xs) if xs else [0]
    )([])[::-1]


# TEST ----------------------------------------------------
def main():
    '''Terms of the Van Eck sequence'''
    print(
        main.__doc__ + ':\n\n' +
        'First 10: '.rjust(18, ' ') + repr(vanEck(10)) + '\n' +
        '991 - 1000: '.rjust(18, ' ') + repr(vanEck(1000)[990:])
    )


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.
       Wrapper containing the result of a computation.
    '''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return {'type': 'Maybe', 'Nothing': True}


# churchNumeral :: Int -> (a -> a) -> a -> a
def churchNumeral(n):
    '''n applications of a function
    '''
    return lambda f: lambda x: reduce(
        lambda a, g: g(a), repeat(f, n), x
    )


# cons :: a -> [a] -> [a]
def cons(x):
    '''Construction of a list from a head and a tail.
    '''
    return lambda xs: [x] + xs


# elemIndex :: Eq a => a -> [a] -> Maybe Int
def elemIndex(x):
    '''Just the index of the first element in xs
       which is equal to x,
       or Nothing if there is no such element.
    '''
    def go(xs):
        try:
            return Just(xs.index(x))
        except ValueError:
            return Nothing()
    return go


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if None is m or m.get('Nothing') else (
        f(m.get('Just'))
    )


# succ :: Enum a => a -> a
def succ(x):
    '''The successor of a value.
       For numeric types, (1 +).
    '''
    return 1 + x


# MAIN ---
if __name__ == '__main__':
    main()
