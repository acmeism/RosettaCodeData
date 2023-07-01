'''Tree from nesting levels'''

from itertools import chain, repeat
from operator import add


# treeFromSparseLevels :: [Int] -> Tree Maybe Int
def treeFromSparseLevels(levelList):
    '''A Forest (list of Trees) of (Maybe Int) values,
       in which implicit nodes have the value None.
    '''
    return Node(None)(
        forestFromLevels(
            rooted(normalized(levelList))
        )
    )


# forestFromLevels :: [(Int, a)] -> [Tree a]
def forestFromLevels(nvs):
    '''A list of generic trees derived from a list of
       values paired with integers representing
       nesting depths.
    '''
    def go(xs):
        if xs:
            level, v = xs[0]
            children, rest = span(
                lambda x: level < x[0]
            )(xs[1:])
            return [Node(v)(go(children))] + go(rest)
        else:
            return []
    return go(nvs)


# bracketNest :: Maybe Int -> Nest -> Nest
def bracketNest(maybeLevel):
    '''An arbitrary nest of bracketed
       lists and sublists.
    '''
    def go(xs):
        subNest = concat(xs)
        return [subNest] if None is maybeLevel else (
            [maybeLevel, subNest] if subNest else (
                [maybeLevel]
            )
        )
    return go


# showTree :: Tree Maybe Int -> String
def showTree(tree):
    '''A string representation of
       a Maybe Int tree.
    '''
    return drawTree(
        fmapTree(repr)(tree)
    )


# sparseLevelsFromTree :: Tree (Maybe Int) -> [Int]
def sparseLevelsFromTree(tree):
    '''Sparse representation of the tree
       a list of nest level integers.
    '''
    def go(x):
        return lambda xs: concat(xs) if (
            None is x
        ) else [x] + concat(xs)
    return foldTree(go)(tree)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test the building and display of
       normalized forests from level integers.
    '''
    for xs in [
        [],
        [1, 2, 4],
        [3, 1, 3, 1],
        [1, 2, 3, 1],
        [3, 2, 1, 3],
        [3, 3, 3, 1, 1, 3, 3, 3]
    ]:
        tree = treeFromSparseLevels(xs)
        (
            print('From: ' + repr(xs)),
            print('Through tuple nest:'),
            print(repr(tree)),
            print('\nTree:'),
            print(showTree(tree)),
            print('\nto bracket nest:'),
            print(
                repr(
                    root(foldTree(bracketNest)(tree))
                )
            ),
            print(
                'and back to: ' + (
                    repr(sparseLevelsFromTree(tree))
                )
            ),
            print()
        )


# ------ TRANSLATION TO A CONSISTENT DATA STRUCTURE ------

# normalized :: [Int] -> [(Int, Maybe Int)]
def normalized(xs):
    '''Explicit representation of implicit nodes.
    '''
    if xs:
        x = xs[0]
        h = [(x, x)]
        return h if 1 == len(xs) else (
            h + [(1 + x, None)] if (
                1 < (xs[1] - x)
            ) else h
        ) + normalized(xs[1:])
    else:
        return []


# rooted :: [(Int, Maybe Int)] -> [(Int, Maybe Int)]
def rooted(pairs):
    '''Path from the virtual root
       to the first explicit node.
    '''
    def go(xs):
        n = xs[0][0]
        return xs if 1 == n else (
            [(x, Nothing()) for x in range(1, n)] + xs
        )
    return go([
        x for x in pairs if 1 <= x[0]
    ]) if pairs else []


# ---------------- GENERIC TREE FUNCTIONS ----------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Constructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.
    '''
    return lambda xs: (v, xs)


# draw :: Tree a -> [String]
def draw(node):
    '''List of the lines of an ASCII
       diagram of a tree.
    '''
    def shift_(h, other, xs):
        return list(map(
            add,
            chain(
                [h], (
                    repeat(other, len(xs) - 1)
                )
            ),
            xs
        ))

    def drawSubTrees(xs):
        return (
            (
                ['|'] + shift_(
                    '├─ ', '│  ', draw(xs[0])
                ) + drawSubTrees(xs[1:])
            ) if 1 < len(xs) else ['|'] + shift_(
                '└─ ', '   ', draw(xs[0])
            )
        ) if xs else []

    return (root(node)).splitlines() + (
        drawSubTrees(nest(node))
    )


# drawForest :: [Tree String] -> String
def drawForest(trees):
    '''A simple unicode character representation of
       a list of trees.
    '''
    return '\n'.join(map(drawTree, trees))


# drawTree :: Tree a -> String
def drawTree(tree):
    '''ASCII diagram of a tree.'''
    return '\n'.join(draw(tree))


# fmapTree :: (a -> b) -> Tree a -> Tree b
def fmapTree(f):
    '''A new tree holding the results of
       an application of f to each root in
       the existing tree.
    '''
    def go(x):
        return Node(
            f(root(x))
        )([go(v) for v in nest(x)])
    return go


# foldTree :: (a -> [b] -> b) -> Tree a -> b
def foldTree(f):
    '''The catamorphism on trees. A summary
       value defined by a depth-first fold.
    '''
    def go(node):
        return f(root(node))([
            go(x) for x in nest(node)
        ])
    return go


# nest :: Tree a -> [Tree a]
def nest(t):
    '''Accessor function for children of tree node.'''
    return t[1]


# root :: Tree a -> a
def root(t):
    '''Accessor function for data of tree node.'''
    return t[0]


# -------------------- GENERIC OTHER ---------------------

# Nothing :: () -> Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.
       Empty wrapper returned where a computation is not possible.
    '''
    return None


# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xs):
    '''The concatenation of all the elements
       in a list or iterable.
    '''
    def f(ys):
        zs = list(chain(*ys))
        return ''.join(zs) if isinstance(ys[0], str) else zs

    return (
        f(xs) if isinstance(xs, list) else (
            chain.from_iterable(xs)
        )
    ) if xs else []


# span :: (a -> Bool) -> [a] -> ([a], [a])
def span(p):
    '''The longest (possibly empty) prefix of xs
    that contains only elements satisfying p,
    tupled with the remainder of xs.
    span p xs is equivalent to
    (takeWhile p xs, dropWhile p xs).
    '''
    def match(ab):
        b = ab[1]
        return not b or not p(b[0])

    def f(ab):
        a, b = ab
        return a + [b[0]], b[1:]

    def go(xs):
        return until(match)(f)(([], xs))
    return go


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
    The initial seed value is x.
    '''
    def go(f):
        def g(x):
            v = x
            while not p(v):
                v = f(v)
            return v
        return g
    return go


# MAIN ---
if __name__ == '__main__':
    main()
