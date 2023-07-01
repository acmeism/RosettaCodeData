'''Identity matrices by maps and equivalent list comprehensions'''

import operator


# idMatrix :: Int -> [[Int]]
def idMatrix(n):
    '''Identity matrix of order n,
       expressed as a nested map.
    '''
    eq = curry(operator.eq)
    xs = range(0, n)
    return list(map(
        lambda x: list(map(
            compose(int)(eq(x)),
            xs
        )),
        xs
    ))


# idMatrix3 :: Int -> [[Int]]
def idMatrix2(n):
    '''Identity matrix of order n,
       expressed as a nested comprehension.
    '''
    xs = range(0, n)
    return ([int(x == y) for x in xs] for y in xs)


# TEST ----------------------------------------------------
def main():
    '''
        Identity matrix of dimension five,
        by two different routes.
    '''
    for f in [idMatrix, idMatrix2]:
        print(
            '\n' + f.__name__ + ':',
            '\n\n' + '\n'.join(map(str, f(5))),
        )


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    return lambda a: lambda b: f(a, b)


# MAIN ---
if __name__ == '__main__':
    main()
