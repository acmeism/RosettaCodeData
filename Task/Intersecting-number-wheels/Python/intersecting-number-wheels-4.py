'''Intersecting number wheels'''

from itertools import cycle, islice
from functools import reduce


# clockWorkTick :: Dict -> (Dict, Char)
def clockWorkTick(wheelMap):
    '''The new state of the wheels, tupled with a
       digit found by recursive descent from a single
       click of the first wheel.'''
    def click(wheels):
        def go(wheelName):
            wheel = wheels.get(wheelName, ['?'])
            v = wheel[0]
            return (Tuple if v.isdigit() or '?' == v else click)(
                insertDict(wheelName)(leftRotate(wheel))(wheels)
            )(v)
        return go
    return click(wheelMap)('A')


# leftRotate :: [a] -> String
def leftRotate(xs):
    ''' A string shifted cyclically towards
        the left by one position.
    '''
    return ''.join(islice(cycle(xs), 1, 1 + len(xs)))


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First twenty values from each set of test wheels.'''

    wheelMaps = [dict(kvs) for kvs in [
        [('A', "123")],
        [('A', "1B2"), ('B', "34")],
        [('A', "1DD"), ('D', "678")],
        [('A', "1BC"), ('B', "34"), ('C', "5B")]
    ]]
    print('New state of wheel sets, after 20 clicks of each:\n')
    for wheels, series in [
            mapAccumL(compose(const)(clockWorkTick))(
                dct
            )(' ' * 20) for dct in wheelMaps
    ]:
        print((wheels, ''.join(series)))

    print('\nInital states:')
    for x in wheelMaps:
        print(x)


# ----------------------- GENERIC ------------------------

# Tuple (,) :: a -> b -> (a, b)
def Tuple(x):
    '''Constructor for a pair of values,
       possibly of two different types.
    '''
    return lambda y: (
        x + (y,)
    ) if isinstance(x, tuple) else (x, y)


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# const :: a -> b -> a
def const(k):
    '''The latter of two arguments,
       with the first discarded.
    '''
    return lambda _: k


# insertDict :: String -> a -> Dict -> Dict
def insertDict(k):
    '''A new dictionary updated with a (k, v) pair.'''
    def go(v, dct):
        return dict(dct, **{k: v})
    return lambda v: lambda dct: go(v, dct)


# mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
def mapAccumL(f):
    '''A tuple of an accumulation and a map
       with accumulation from left to right.
    '''
    def nxt(a, x):
        tpl = f(a[0])(x)
        return tpl[0], a[1] + [tpl[1]]

    def go(acc):
        def g(xs):
            return reduce(nxt, xs, (acc, []))
        return g
    return go


# MAIN ---
if __name__ == '__main__':
    main()
