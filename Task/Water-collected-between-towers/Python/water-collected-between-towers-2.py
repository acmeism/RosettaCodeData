'''Water collected between towers'''

from itertools import accumulate
from functools import reduce
from operator import add


# ---------------------- TOWER POOLS -----------------------

# towerPools :: [Int] -> [(Int, Int)]
def towerPools(towers):
    '''Tower heights with water depths.
    '''
    def towerAndWater(level, tower):
        return tower, level - tower

    waterlevels = map(
        min,
        accumulate(towers, max),
        reversed(list(
            accumulate(reversed(towers), max)
        )),
    )
    return list(map(towerAndWater, waterlevels, towers))


# ------------------------ DIAGRAMS ------------------------

# showTowers :: [(Int, Int)] -> String
def showTowers(xs):
    '''Diagrammatic representation.
    '''
    upper = max(xs, key=fst)[0]

    def row(xd):
        return ' ' * (upper - add(*xd)) + (
            snd(xd) * 'x' + '██' * fst(xd)
        )
    return unlines([
        ''.join(x) for x in zip(*map(row, xs))
    ])


# showLegend :: (Int, Int)] -> String
def showLegend(xs):
    '''String display of tower heights and
       total sum of trapped water units.
    '''
    towers, depths = zip(*xs)
    return showList(towers) + (
        ' -> ' + str(sum(depths))
    )


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Water collected in various flooded bar charts.'''
    def diagram(xs):
        return showTowers(xs) + '\n\n' + (
            showLegend(xs) + '\n\n'
        )

    print(unlines(
        map(compose(diagram, towerPools), [
            [1, 5, 3, 7, 2],
            [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
            [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
            [5, 5, 5, 5],
            [5, 6, 7, 8],
            [8, 7, 7, 6],
            [6, 7, 10, 7, 6]
        ])
    ))


# ------------------------ GENERIC -------------------------

# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    def go(f, g):
        return lambda x: f(g(x))
    return reduce(go, fs, lambda x: x)


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# showList :: [a] -> String
def showList(xs):
    '''Stringification of a list.'''
    return '[' + ','.join(str(x) for x in xs) + ']'


# snd :: (a, b) -> b
def snd(tpl):
    '''Second member of a pair.'''
    return tpl[1]


# unlines :: [String] -> String
def unlines(xs):
    '''A single string formed by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
