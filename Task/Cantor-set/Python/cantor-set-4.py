'''A Cantor set generator, and two different
   representations of its output.
'''

from itertools import (islice, chain)
from fractions import Fraction
from functools import (reduce)


# ----------------------- CANTOR SET -----------------------

# cantor :: Generator [[(Fraction, Fraction)]]
def cantor():
    '''A non-finite stream of successive Cantor
       partitions of the line, in the form of
       lists of fraction pairs.
    '''
    def go(xy):
        (x, y) = xy
        third = Fraction(y - x, 3)
        return [(x, x + third), (y - third, y)]

    return iterate(
        concatMap(go)
    )(
        [(0, 1)]
    )


# fractionLists :: [(Fraction, Fraction)] -> String
def fractionLists(xs):
    '''A fraction pair representation of a
       Cantor-partitioned line.
    '''
    def go(xy):
        return ', '.join(map(showRatio, xy))
    return ' '.join('(' + go(x) + ')' for x in xs)


# intervalBars :: [(Fraction, Fraction)] -> String
def intervalBars(w):
    '''A block diagram representation of a
       Cantor-partitioned line.
    '''
    def go(xs):
        def show(a, tpl):
            [x, y] = [int(w * r) for r in tpl]
            return (
                y,
                (' ' * (x - a)) + ('█' * (y - x))
            )
        return mapAccumL(show)(0)(xs)
    return lambda xs: ''.join(go(xs)[1])


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Testing the generation of successive
       Cantor subdivisions of the line, and
       displaying them both as lines of fraction
       pairs and as graphic interval bars.
    '''
    xs = list(islice(cantor(), 4))
    w = max(xy[1].denominator for xy in xs[-1])
    print(
        '\n'.join(map(fractionLists, xs)),
        '\n'
    )
    print(
        '\n'.join(map(intervalBars(w), xs))
    )


# ------------------------ GENERIC -------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
    )


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


# mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
def mapAccumL(f):
    '''A tuple of an accumulation and a list derived by a
       combined map and fold,
       with accumulation from left to right.
    '''
    def go(a, x):
        tpl = f(a[0], x)
        return (tpl[0], a[1] + [tpl[1]])
    return lambda acc: lambda xs: (
        reduce(go, xs, (acc, []))
    )


# showRatio :: Ratio -> String
def showRatio(r):
    '''String representation of the ratio r.'''
    d = r.denominator
    return str(r.numerator) + (
        '/' + str(d) if 1 != d else ''
    )


# MAIN ---
if __name__ == '__main__':
    main()
