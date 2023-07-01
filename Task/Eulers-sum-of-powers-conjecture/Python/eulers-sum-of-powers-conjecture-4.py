'''Euler's sum of powers conjecture'''

from itertools import (chain, takewhile)


# main :: IO ()
def main():
    '''Search for counter-example'''

    xs = enumFromTo(1)(249)

    powerMap = {x**5: x for x in xs}
    sumMap = {
        x**5 + y**5: (x, y)
        for x in xs[1:]
        for y in xs if x > y
    }

    # isExample :: (Int, Int) -> Bool
    def isExample(ps):
        p, s = ps
        return p - s in sumMap

    # display :: (Int, Int) -> String
    def display(ps):
        p, s = ps
        a, b = sumMap[p - s]
        c, d = sumMap[s]
        return '^5 + '.join([str(n) for n in [a, b, c, d]]) + (
            '^5 = ' + str(powerMap[p]) + '^5'
        )

    print(__doc__ + ' – counter-example:\n')
    print(
        maybe('No counter-example found.')(display)(
            find(isExample)(
                bind(powerMap.keys())(
                    lambda p: bind(
                        takewhile(
                            lambda x: p > x,
                            sumMap.keys()
                        )
                    )(lambda s: [(p, s)])
                )
            )
        )
    )


# ----------------------- GENERIC ------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.
       Wrapper containing the result of a computation.
    '''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: () -> Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return {'type': 'Maybe', 'Nothing': True}


# bind (>>=) :: [a] -> (a -> [b]) -> [b]
def bind(xs):
    '''List monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.
    '''
    def go(f):
        return chain.from_iterable(map(f, xs))
    return go


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: range(m, 1 + n)


# find :: (a -> Bool) -> [a] -> Maybe a
def find(p):
    '''Just the first element in the list that matches p,
       or Nothing if no elements match.
    '''
    def go(xs):
        try:
            return Just(next(x for x in xs if p(x)))
        except StopIteration:
            return Nothing()
    return go


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).
    '''
    return lambda f: lambda m: v if (
        None is m or m.get('Nothing')
    ) else f(m.get('Just'))


# MAIN ---
if __name__ == '__main__':
    main()
