'''100 Prisoners'''

from random import randint, sample


# allChainedPathsAreShort :: Int -> IO (0|1)
def allChainedPathsAreShort(n):
    '''1 if none of the index-chasing cycles in a shuffled
       sample of [1..n] cards are longer than half the
       sample size. Otherwise, 0.
    '''
    limit = n // 2
    xs = range(1, 1 + n)
    shuffled = sample(xs, k=n)

    # A cycle of boxes, drawn from a shuffled
    # sample, which includes the given target.
    def cycleIncluding(target):
        boxChain = [target]
        v = shuffled[target - 1]
        while v != target:
            boxChain.append(v)
            v = shuffled[v - 1]
        return boxChain

    # Nothing if the target list is empty, or if the cycle which contains the
    # first target is larger than half the sample size.
    # Otherwise, just a cycle of enchained boxes containing the first target
    # in the list, tupled with the residue of any remaining targets which
    # fall outside that cycle.
    def boxCycle(targets):
        if targets:
            boxChain = cycleIncluding(targets[0])
            return Just((
                difference(targets[1:])(boxChain),
                boxChain
            )) if limit >= len(boxChain) else Nothing()
        else:
            return Nothing()

    # No cycles longer than half of total box count ?
    return int(n == sum(map(len, unfoldr(boxCycle)(xs))))


# randomTrialResult :: RandomIO (0|1) -> Int -> (0|1)
def randomTrialResult(coin):
    '''1 if every one of the prisoners finds their ticket
       in an arbitrary half of the sample. Otherwise 0.
    '''
    return lambda n: int(all(
        coin(x) for x in range(1, 1 + n)
    ))


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Two sampling techniques constrasted with 100 drawers
       and 100 prisoners, over 100,000 trial runs.
    '''
    halfOfDrawers = randomRInt(0)(1)

    def optimalDrawerSampling(x):
        return allChainedPathsAreShort(x)

    def randomDrawerSampling(x):
        return randomTrialResult(halfOfDrawers)(x)

    # kSamplesWithNBoxes :: Int -> Int -> String
    def kSamplesWithNBoxes(k):
        tests = range(1, 1 + k)
        return lambda n: '\n\n' + fTable(
            str(k) + ' tests of optimal vs random drawer-sampling ' +
            'with ' + str(n) + ' boxes: \n'
        )(fName)(lambda r: '{:.2%}'.format(r))(
            lambda f: sum(f(n) for x in tests) / k
        )([
            optimalDrawerSampling,
            randomDrawerSampling,
        ])

    print(kSamplesWithNBoxes(10000)(10))

    print(kSamplesWithNBoxes(10000)(100))

    print(kSamplesWithNBoxes(100000)(100))


# ------------------------DISPLAY--------------------------

# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
       f -> xs -> tabular string.
    '''
    def go(xShow, fxShow, f, xs):
        ys = [xShow(x) for x in xs]
        w = max(map(len, ys))
        return s + '\n' + '\n'.join(map(
            lambda x, y: y.rjust(w, ' ') + ' -> ' + fxShow(f(x)),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# fname :: (a -> b) -> String
def fName(f):
    '''Name bound to the given function.'''
    return f.__name__


# ------------------------GENERIC -------------------------

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


# difference :: Eq a => [a] -> [a] -> [a]
def difference(xs):
    '''All elements of xs, except any also found in ys.'''
    return lambda ys: list(set(xs) - set(ys))


# randomRInt :: Int -> Int -> IO () -> Int
def randomRInt(m):
    '''The return value of randomRInt is itself
       a function. The returned function, whenever
       called, yields a a new pseudo-random integer
       in the range [m..n].
    '''
    return lambda n: lambda _: randint(m, n)


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
