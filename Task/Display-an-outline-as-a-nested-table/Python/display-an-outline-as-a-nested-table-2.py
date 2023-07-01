'''Display an outline as a nested table'''

from itertools import chain, cycle, takewhile
from functools import reduce
from operator import add


# wikiTablesFromOutline :: [String] -> String -> String
def wikiTablesFromOutline(colorSwatch):
    '''Wikitable markup for (colspan) tables representing
       the indentation of a given outline.
       Each key-line point (child of a tree root) has a
       distinct color, inherited by all its descendants.
       The first color in the swatch is for the root node.
       A sequence of tables is generated where the outline
       represents a forest rather than a singly-rooted tree.
    '''
    def go(outline):
        return '\n\n'.join([
            wikiTableFromTree(colorSwatch)(tree) for tree in
            forestFromLevels(
                indentLevelsFromLines(
                    outline.splitlines()
                )
            )
        ])
    return go


#  wikiTableFromTree :: [String] -> Tree String -> String
def wikiTableFromTree(colorSwatch):
    '''A wikitable rendered from a single tree.
    '''
    return compose(
        wikiTableFromRows,
        levels,
        paintedTree(colorSwatch),
        widthMeasuredTree,
        ap(paddedTree(""))(treeDepth)
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''A colored wikitable rendering of a given outline'''

    outline = '''Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.'''

    print(
        wikiTablesFromOutline([
            "#ffffe6",
            "#ffebd2",
            "#f0fff0",
            "#e6ffff",
            "#ffeeff"
        ])(outline)
    )


# ------------------ TREE FROM OUTLINE -------------------

# indentLevelsFromLines :: [String] -> [(Int, String)]
def indentLevelsFromLines(xs):
    '''Each input line stripped of leading
       white space, and tupled with a preceding integer
       giving its level of indentation from 0 upwards.
    '''
    indentTextPairs = [
        (n, s[n:]) for (n, s)
        in (
            (len(list(takewhile(isSpace, x))), x)
            for x in xs
        )
    ]
    indentUnit = len(next(
        x for x in indentTextPairs if x[0]
    )) or 1
    return [
        (x[0] // indentUnit, x[1])
        for x in indentTextPairs
    ]


# forestFromLevels :: [(Int, String)] -> [Tree a]
def forestFromLevels(levelValuePairs):
    '''A list of trees derived from a list of values paired
       with integers giving their levels of indentation.
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
    return go(levelValuePairs)


# -------------- TREE PADDED TO EVEN DEPTH ---------------

# paddedTree :: a -> (Int, Node a) -> Node a
def paddedTree(padValue):
    '''A tree vertically padded to a given depth,
       with additional nodes, containing padValue,
       where needed.
    '''
    def go(tree):
        def pad(n):
            prev = n - 1
            return Node(tree.get('root'))([
                go(x)(prev) for x in (
                    tree.get('nest') or [Node(padValue)([])]
                )
            ]) if prev else tree
        return pad
    return go


# treeDepth :: Tree a -> Int
def treeDepth(tree):
    '''Maximum number of distinct levels in the tree.
    '''
    def go(_, xs):
        return 1 + max(xs) if xs else 1
    return foldTree(go)(tree)


# ------------ SPANNING WIDTH OF EACH SUBTREE ------------

# widthMeasuredTree :: Tree a -> Tree (a, Int)
def widthMeasuredTree(tree):
    '''A tree in which each node value is tupled
       with the width of the subtree.
    '''
    def go(x, xs):
        return Node((x, 1))([]) if not xs else (
            Node((x, reduce(
                lambda a, child: a + (
                    child.get('root')[1]
                ),
                xs,
                0
            )))(xs)
        )
    return foldTree(go)(tree)


# ----------------- COLOR SWATCH APPLIED -----------------

# paintedTree :: [String] -> Tree a -> Tree (String, a)
def paintedTree(swatch):
    '''A tree in which every node value is tupled with
       a hexadecimal color string taken from a swatch list.
       The first colour is used for the root node.
       The next n colours paint the root's n children.
       All descendants of those children are painted with
       the same color as their non-root ancestor.
    '''
    colors = cycle(swatch)

    def go(tree):
        return fmapTree(
            lambda x: ("", x)
        )(tree) if not swatch else (
            Node(
                (next(colors), tree.get('root'))
            )(
                list(map(
                    lambda k, child: fmapTree(
                        lambda v: (k, v)
                    )(child),
                    colors,
                    tree.get('nest')
                ))
            )
        )
    return go


# ---------------- GENERIC TREE FUNCTIONS ----------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Constructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.
    '''
    return lambda xs: {'root': v, 'nest': xs}


# fmapTree :: (a -> b) -> Tree a -> Tree b
def fmapTree(f):
    '''A new tree holding the results of
       an application of f to each root in
       the existing tree.
    '''
    def go(x):
        return Node(
            f(x.get('root'))
        )([go(v) for v in x.get('nest')])
    return go


# foldTree :: (a -> [b] -> b) -> Tree a -> b
def foldTree(f):
    '''The catamorphism on trees. A summary
       value defined by a depth-first fold.
    '''
    def go(node):
        return f(
            node.get('root'),
            [go(x) for x in node.get('nest')]
        )
    return go


# levels :: Tree a -> [[a]]
def levels(tree):
    '''A list of lists, grouping the root
       values of each level of the tree.
    '''
    return [[tree.get('root')]] + list(
        reduce(
            zipWithLong(add),
            map(levels, tree.get('nest')),
            []
        )
    )


# ----------------- WIKITABLE RENDERING ------------------

# wikiTableFromRows :: [[(String, (String, Int))]] -> String
def wikiTableFromRows(rows):
    '''A wiki table rendering of rows in which each cell
       has the form (hexColorString, (text, colspan))
    '''
    def cw(color, width):
        def go(w):
            return f' colspan={w}' if 1 < w else ''
        return f'style="background: {color}; "{go(width)}'

    def cellText(cell):
        color, (txt, width) = cell
        return f'| {cw(color,width) if txt else ""} | {txt}'

    def go(row):
        return '\n'.join([cellText(cell) for cell in row])

    return '{| class="wikitable" ' + (
        'style="text-align: center;"\n|-\n'
    ) + '\n|-\n'.join([go(row) for row in rows]) + '\n|}'


# ----------------------- GENERIC ------------------------

# ap :: (a -> b -> c) -> (a -> b) -> a -> c
def ap(f):
    '''Applicative instance for functions.
    '''
    def go(g):
        return lambda x: f(x)(g(x))
    return go

# compose :: ((a -> a), ...) -> (a -> a)


def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    def go(f, g):
        def fg(x):
            return f(g(x))
        return fg
    return reduce(go, fs, lambda x: x)


# head :: [a] -> a
def head(xs):
    '''The first element of a non-empty list.
    '''
    return xs[0] if isinstance(xs, list) else next(xs)


# isSpace :: Char -> Bool
# isSpace :: String -> Bool
def isSpace(s):
    '''True if s is not empty, and
       contains only white space.
    '''
    return s.isspace()


# span :: (a -> Bool) -> [a] -> ([a], [a])
def span(p):
    '''The longest (possibly empty) prefix of xs that
       contains only elements satisfying p, tupled with the
       remainder of xs.  span p xs is equivalent to
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


# zipWithLong :: ((a, a) -> a) -> ([a], [a]) -> [a]
def zipWithLong(f):
    '''Analogous to map(f, xs, ys)
       but returns a list with the length of the *longer*
       of xs and ys, taking any surplus values unmodified.
    '''
    def go(xs, ys):
        lxs = list(xs)
        lys = list(ys)
        i = min(len(lxs), len(lys))
        return chain.from_iterable([
            map(f, lxs, lys),
            lxs[i:],
            lys[i:]
        ])
    return go


# MAIN ---
if __name__ == '__main__':
    main()
