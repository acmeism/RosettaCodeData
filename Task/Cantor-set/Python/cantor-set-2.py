'''Cantor set – separating model from display'''

from functools import (reduce)
import itertools


# cantor :: [(Bool, Int)] -> [(Bool, Int)]
def cantor(xs):
    '''A Cantor segmentation step.'''
    def go(tpl):
        (bln, n) = tpl
        m = n // 3
        return [
            (True, m), (False, m), (True, m)
        ] if bln and (1 < n) else [tpl]
    return concatMap(go)(xs)


# cantorLines :: Int -> String
def cantorLines(n):
    '''A text block display of n
       Cantor-segmented lines.
    '''
    m = n - 1
    repeat = itertools.repeat
    return '\n'.join(
        [showCantor(x) for x in (
            reduce(
                lambda a, f: a + [f(a[-1])],
                repeat(cantor, m),
                [[(True, 3 ** m)]]
            )
        )]
    )


# showCantor :: [(Bool, Int)] -> String
def showCantor(xs):
    '''A text block display of a list of
       Cantor line segments.
    '''
    return ''.join(
        concatMap(lambda tpl: tpl[1] * ('█' if tpl[0] else ' '))(
            xs
        )
    )


# main :: IO ()
def main():
    '''Testing to depth 5'''

    print(
        cantorLines(5)
    )


# GENERIC -------------------------------------------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).'''
    chain = itertools.chain
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
    )


# MAIN ---
if __name__ == '__main__':
    main()
