'''Sleeping Beauty Problem'''

from random import choice
from itertools import repeat
from functools import reduce


# experiment :: (Int, Int) -> IO (Int, Int)
def experiment(headsWakings):
    '''A pair of counts updated by a coin flip.
    '''
    heads, wakings = headsWakings

    return (
        1 + heads, 1 + wakings
    ) if "h" == choice(["h", "t"]) else (
        heads, 2 + wakings
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Observed results from one million runs.'''

    n = 1_000_000
    heads, wakes = applyN(n)(
        experiment
    )(
        (0, 0)
    )

    print(
        f'{wakes} wakenings over {n} experiments.\n'
    )
    print('Sleeping Beauty should estimate credence')
    print(f'at around {round(heads/wakes, 3)}')


# ----------------------- GENERIC ------------------------

# applyN :: Int -> (a -> a) -> a -> a
def applyN(n):
    '''n applications of f.
       (Church numeral n).
    '''
    def go(f):
        def ga(a, g):
            return g(a)

        def fn(x):
            return reduce(ga, repeat(f, n), x)
        return fn
    return go


# MAIN ---
if __name__ == '__main__':
    main()
