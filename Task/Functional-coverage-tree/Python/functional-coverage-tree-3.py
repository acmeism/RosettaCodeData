'''Functional coverage tree'''

from itertools import chain, product
from functools import reduce


# main :: IO ()
def main():
    '''Tabular outline serialisation of a parse tree
       decorated with computations of:
       1. Weighted coverage of each tree node.
       2. Each node's share of the total project's
          remaining work.
    '''
    columnWidths = [31, 9, 9, 9]
    delimiter = '|'

    reportLines = REPORT.splitlines()
    columnTitles = init(columnNames(delimiter)(reportLines[0]))

    # ------ SERIALISATION OF DECORATED PARSE TREE -------
    print(titleLine(delimiter)(columnWidths)(
        columnTitles + ['share of residue']
    ))
    print(indentedLinesFromTree('    ', tabulation(columnWidths))(

        # -------- TWO COMPUTATIONS BY TRAVERSAL ---------
        withResidueShares(1.0)(
            foldTree(weightedCoverage)(

                # --- TREE FROM PARSE OF OUTLINE TEXT ----
                fmapTree(
                    recordFromKeysDefaultsDelimiterAndLine(
                        columnTitles
                    )(
                        [str, float, float])([
                            '?', 1.0, 0.0
                        ])(delimiter)
                )(
                    forestFromIndentLevels(
                        indentLevelsFromLines(
                            reportLines[1:]
                        )
                    )[0]
                )
            )
        )
    ))


# ---- WEIGHTED COVERAGE, AND SHARE OF TOTAL RESIDUE -----

# weightedCoverage :: Tree Dict ->
# [Tree Dict] -> Tree Dict
def weightedCoverage(x):
    '''The weighted coverage of a tree node,
       as a function of the weighted averages
       of its children.
    '''
    def go(xs):
        cws = [
            (r['coverage'], r['weight']) for r
            in [root(x) for x in xs]
        ]
        totalWeight = reduce(lambda a, x: a + x[1], cws, 0)
        return Node(dict(
            x, **{
                'coverage': round(reduce(
                    lambda a, cw: a + (cw[0] * cw[1]),
                    cws, x['coverage']
                ) / (totalWeight if 0 < totalWeight else 1), 5)
            }
        ))(xs)
    return go


# withResidueShares :: Float -> Tree Dict -> Tree Dict
def withResidueShares(shareOfTotal):
    '''A Tree of dictionaries additionally decorated with each
       node's proportion of the total project's outstanding work.
    '''
    def go(fraction, node):
        [nodeRoot, nodeNest] = ap([root, nest])([node])
        weights = [root(x)['weight'] for x in nodeNest]
        siblingsTotal = sum(weights)
        return Node(
            insertDict('residual_share')(
                round(fraction * (1 - nodeRoot['coverage']), 5)
            )(nodeRoot)
        )(
            map(
                go,
                [fraction * (w / siblingsTotal) for w in weights],
                nodeNest
            )
        )
    return lambda tree: go(shareOfTotal, tree)


# ------------------ OUTLINE TABULATION ------------------

# tabulation :: [Int] -> String -> Dict -> String
def tabulation(columnWidths):
    '''Indented string representation of a node
       in a functional coverage tree.
    '''
    return lambda indent, dct: '| '.join(map(
        lambda k, w: (
            (indent if 10 < w else '') + str(dct.get(k, ''))
        ).ljust(w, ' '),
        dct.keys(),
        columnWidths
    ))


# titleLine :: String -> [Int] -> [String] -> String
def titleLine(delimiter):
    '''A string consisting of a spaced and delimited
       series of upper-case column titles.
    '''
    return lambda columnWidths: lambda ks: (
        delimiter + ' '
    ).join(map(
        lambda k, w: k.ljust(w, ' '),
        [k.upper() for k in ks],
        columnWidths
    ))


# ------------ GENERIC AND REUSABLE FUNCTIONS ------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Constructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.
    '''
    return lambda xs: {'type': 'Tree', 'root': v, 'nest': xs}


# ap (<*>) :: [(a -> b)] -> [a] -> [b]
def ap(fs):
    '''The application of each of a list of functions,
       to each of a list of values.
    '''
    def go(xs):
        return [
            f(x) for (f, x)
            in product(fs, xs)
        ]
    return go


# columnNames :: String -> String -> [String]
def columnNames(delimiter):
    '''A list of lower-case keys derived from
       a header line and a delimiter character.
    '''
    return compose(
        fmapList(compose(toLower, strip)),
        splitOn(delimiter)
    )


# compose :: ((a -> a), ...) -> (a -> a)
def compose(*fs):
    '''Composition, from right to left,
       of a series of functions.
    '''
    return lambda x: reduce(
        lambda a, f: f(a),
        fs[::-1], x
    )


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


# div :: Int -> Int -> Int
def div(x):
    '''Integer division.'''
    return lambda y: x // y


# first :: (a -> b) -> ((a, c) -> (b, c))
def first(f):
    '''A simple function lifted to a function over a tuple,
       with f applied only the first of two values.
    '''
    return lambda xy: (f(xy[0]), xy[1])


# flip :: (a -> b -> c) -> b -> a -> c
def flip(f):
    '''The (curried or uncurried) function f with its
       arguments reversed.
    '''
    return lambda a: lambda b: f(b)(a)


# fmapList :: (a -> b) -> [a] -> [b]
def fmapList(f):
    '''fmap over a list.
       f lifted to a function over a list.
    '''
    return lambda xs: [f(x) for x in xs]


# fmapTree :: (a -> b) -> Tree a -> Tree b
def fmapTree(f):
    '''A new tree holding the results of
       an application of f to each root in
       the existing tree.
    '''
    def go(x):
        return Node(
            f(x['root'])
        )([go(v) for v in x['nest']])
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


# forestFromIndentLevels :: [(Int, a)] -> [Tree a]
def forestFromIndentLevels(tuples):
    '''A list of trees derived from a list of values paired
       with integers giving their levels of indentation.
    '''
    def go(xs):
        if xs:
            intIndent, v = xs[0]
            firstTreeLines, rest = span(
                lambda x: intIndent < x[0]
            )(xs[1:])
            return [Node(v)(go(firstTreeLines))] + go(rest)
        else:
            return []
    return go(tuples)


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# indentLevelsFromLines :: [String] -> [(Int, String)]
def indentLevelsFromLines(xs):
    '''Each input line stripped of leading
       white space, and tupled with a preceding integer
       giving its level of indentation from 0 upwards.
    '''
    indentTextPairs = list(map(
        compose(first(len), span(isSpace)),
        xs
    ))
    indentUnit = min(concatMap(
        lambda x: [x[0]] if x[0] else []
    )(indentTextPairs))
    return list(map(
        first(flip(div)(indentUnit)),
        indentTextPairs
    ))


# indentedLinesFromTree :: String -> (String -> a -> String) ->
# [Tree a] -> String
def indentedLinesFromTree(strTab, f):
    '''An indented line rendering of a tree, in which
       the function f stringifies a root value.
    '''
    def go(indent):
        return lambda node: [f(indent, node['root'])] + list(
            concatMap(
                go(strTab + indent)
            )(node['nest'])
        )
    return lambda tree: '\n'.join(go('')(tree))


# init :: [a] -> [a]
def init(xs):
    '''A list containing all the elements
       of xs except the last.
    '''
    return xs[:-1]


# insertDict :: String -> a -> Dict -> Dict
def insertDict(k):
    '''A new dictionary updated with a (k, v) pair.'''
    def go(v, dct):
        return dict(dct, **{k: v})
    return lambda v: lambda dct: go(v, dct)


# isSpace :: Char -> Bool
# isSpace :: String -> Bool
def isSpace(s):
    '''True if s is not empty, and
       contains only white space.
    '''
    return s.isspace()


# lt (<) :: Ord a => a -> a -> Bool
def lt(x):
    '''True if x < y.'''
    return lambda y: (x < y)


# nest :: Tree a -> [Tree a]
def nest(t):
    '''Accessor function for children of tree node.'''
    return t['nest'] if 'nest' in t else None


# recordFromKeysDefaultsAndLine :: String ->
# { name :: String, weight :: Float, completion :: Float }
def recordFromKeysDefaultsDelimiterAndLine(columnTitles):
    '''A dictionary of key-value pairs, derived from a
       delimited string, together with ordered lists of
       key-names, types, default values, and a delimiter.
    '''
    return lambda ts: lambda vs: lambda delim: lambda s: dict(
        map(
            lambda k, t, v, x: (k, t(x) if x else v),
            columnTitles, ts, vs,
            map(strip, splitOn(delim)(s))
        )
    )


# root :: Tree a -> a
def root(t):
    '''Accessor function for data of tree node.'''
    return t['root'] if 'root' in t else None


# strip :: String -> String
def strip(s):
    '''A copy of s without any leading or trailling
       white space.
    '''
    return s.strip()


# span :: (a -> Bool) -> [a] -> ([a], [a])
def span(p):
    '''The longest (possibly empty) prefix of xs
       that contains only elements satisfying p,
       tupled with the remainder of xs.
       span p xs is equivalent to (takeWhile p xs, dropWhile p xs).
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


# splitOn :: String -> String -> [String]
def splitOn(pat):
    '''A list of the strings delimited by
       instances of a given pattern in s.
    '''
    return lambda xs: (
        xs.split(pat) if isinstance(xs, str) else None
    )


# toLower :: String -> String
def toLower(s):
    '''String in lower case.'''
    return s.lower()


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


# MAIN ----------------------------------------------------
if __name__ == '__main__':
    REPORT = '''NAME_HIERARCHY                  |WEIGHT  |COVERAGE  |
    cleaning                        |        |          |
        house1                      |40      |          |
            bedrooms                |        |0.25      |
            bathrooms               |        |          |
                bathroom1           |        |0.5       |
                bathroom2           |        |          |
                outside_lavatory    |        |1         |
            attic                   |        |0.75      |
            kitchen                 |        |0.1       |
            living_rooms            |        |          |
                lounge              |        |          |
                dining_room         |        |          |
                conservatory        |        |          |
                playroom            |        |1         |
            basement                |        |          |
            garage                  |        |          |
            garden                  |        |0.8       |
        house2                      |60      |          |
            upstairs                |        |          |
                bedrooms            |        |          |
                    suite_1         |        |          |
                    suite_2         |        |          |
                    bedroom_3       |        |          |
                    bedroom_4       |        |          |
                bathroom            |        |          |
                toilet              |        |          |
                attics              |        |0.6       |
            groundfloor             |        |          |
                kitchen             |        |          |
                living_rooms        |        |          |
                    lounge          |        |          |
                    dining_room     |        |          |
                    conservatory    |        |          |
                    playroom        |        |          |
                wet_room_&_toilet   |        |          |
                garage              |        |          |
                garden              |        |0.9       |
                hot_tub_suite       |        |1         |
            basement                |        |          |
                cellars             |        |1         |
                wine_cellar         |        |1         |
                cinema              |        |0.75      |'''
    main()
