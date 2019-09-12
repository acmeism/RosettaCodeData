'''Generalised multiplication tables'''

import collections
import itertools
import inspect


# table :: Int -> [[Maybe Int]]
def table(xs):
    '''An option-type model of a multiplication table:
       a tabulation of Just(x * y) values for all
       pairings (x, y) of integers in xs where x > y,
       and Nothing values where y <= x.
    '''
    axis = fmap(Just)(xs)
    return list(cons(
        cons(Nothing())(axis)
    )(zipWith(cons)(axis)([
        [
            Nothing() if y > x else Just(x * y)
            for x in xs
        ]
        for y in xs
    ])))


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''
    print('\n\n'.join(
        fmap(fmap(fmap(showTable)(table))(
            liftA2(enumFromTo)(fst)(snd)
        ))(
            [(13, 20), (1, 12), (95, 100)]
        )
    ))


# DISPLAY -------------------------------------------------

# showTable :: [[Maybe Int]] -> String
def showTable(xs):
    '''A stringification of an abstract model
       of a multiplication table.
    '''
    w = 1 + len(str(last(last(xs))['Just']))
    gap = ' ' * w
    rows = fmap(fmap(concat)(
        fmap(maybe(gap)(
            fmap(justifyRight(w)(' '))(str)
        ))
    ))(xs)
    return unlines([rows[0]] + [''] + rows[1:])


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xs):
    '''The concatenation of all the elements
       in a list or iterable.'''
    chain = itertools.chain

    def f(ys):
        zs = list(chain(*ys))
        return ''.join(zs) if isinstance(ys[0], str) else zs

    return (
        f(xs) if isinstance(xs, list) else (
            chain.from_iterable(xs)
        )
    ) if xs else []


# cons :: a -> [a] -> [a]
def cons(x):
    '''Construction of a list from x as head,
       and xs as tail.'''
    chain = itertools.chain
    return lambda xs: [x] + xs if (
        isinstance(xs, list)
    ) else chain([x], xs)


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    signature = inspect.signature
    if 1 < len(signature(f).parameters):
        return lambda x: lambda y: f(x, y)
    else:
        return f


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# fmap :: Functor f => (a -> b) -> f a -> f b
def fmap(f):
    '''A function f mapped over a functor.'''
    def go(x):
        defaultdict = collections.defaultdict
        return defaultdict(list, [
            ('list', fmapList),
            # ('iter', fmapNext),
            # ('Either', fmapLR),
            # ('Maybe', fmapMay),
            # ('Tree', fmapTree),
            # ('tuple', fmapTuple),
            ('function', fmapFn),
            ('type', fmapFn)
        ])[
            typeName(x)
        ](f)(x)
    return lambda v: go(v)


# fmapFn :: (a -> b) -> (r -> a) -> r -> b
def fmapFn(f):
    '''fmap over a function.
       The composition of f and g.
    '''
    return lambda g: lambda x: f(g(x))


# fmapList :: (a -> b) -> [a] -> [b]
def fmapList(f):
    '''fmap over a list.
       f lifted to a function over a list.
    '''
    return lambda xs: list(map(f, xs))


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# justifyRight :: Int -> Char -> String -> String
def justifyRight(n):
    '''A string padded at left to length n,
       using the padding character c.
    '''
    return lambda c: lambda s: s.rjust(n, c)


# last :: [a] -> a
def last(xs):
    '''The last element of a non-empty list.'''
    return xs[-1]


# liftA2 :: (a -> b -> c) -> f a -> f b -> f c
def liftA2(f):
    '''Lift a binary function to the type of a.'''
    def go(a, b):
        defaultdict = collections.defaultdict
        return defaultdict(list, [
            # ('list', liftA2List),
            # ('Either', liftA2LR),
            # ('Maybe', liftA2May),
            # ('Tree', liftA2Tree),
            # ('tuple', liftA2Tuple),
            ('function', liftA2Fn)
        ])[
            typeName(a)
        ](f)(a)(b)
    return lambda a: lambda b: go(a, b)


# liftA2Fn :: (a0 -> b -> c) -> (a -> a0) -> (a -> b) -> a -> c
def liftA2Fn(op):
    '''Lift a binary function to a composition
       over two other functions.
       liftA2 (*) (+ 2) (+ 3) 7 == 90
    '''
    def go(f, g):
        return lambda x: curry(op)(
            f(x)
        )(g(x))
    return lambda f: lambda g: go(f, g)


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if m.get('Nothing') else (
        f(m.get('Just'))
    )


# typeName :: a -> String
def typeName(x):
    '''Name string for a built-in or user-defined type.
       Selector for type-specific instances
       of polymorphic functions.
    '''
    if isinstance(x, dict):
        return x.get('type') if 'type' in x else 'dict'
    else:
        return 'iter' if hasattr(x, '__next__') else (
            type(x).__name__
        )


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    '''A function over a pair of arguments,
       derived from a vanilla or curried function.
    '''
    signature = inspect.signature
    if 1 < len(signature(f).parameters):
        return lambda xy: f(*xy)
    else:
        return lambda x, y: f(x)(y)


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
def zipWith(f):
    '''A list constructed by zipping with a
       custom function, rather than with the
       default tuple constructor.
    '''
    return lambda xs: lambda ys: (
        map(uncurry(f), xs, ys)
    )


# MAIN ---
if __name__ == '__main__':
    main()
