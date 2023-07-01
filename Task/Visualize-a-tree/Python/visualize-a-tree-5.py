'''Textually visualized tree, with vertically-centered parent nodes'''

from functools import reduce
from itertools import (chain, takewhile)

'''
               ┌ Epsilon
               ├─── Zeta
       ┌─ Beta ┼──── Eta
       │       │         ┌───── Mu
       │       └── Theta ┤
 Alpha ┤                 └───── Nu
       ├ Gamma ────── Xi ─ Omicron
       │       ┌─── Iota
       └ Delta ┼── Kappa
               └─ Lambda
'''
# Tree style and algorithm inspired by the Haskell snippet at:
# https://doisinkidney.com/snippets/drawing-trees.html


# drawTree2 :: Bool -> Bool -> Tree a -> String
def drawTree2(blnCompact):
    '''Monospaced UTF8 left-to-right text tree in a
       compact or expanded format, with any lines
       containing no nodes optionally pruned out.
    '''
    def go(blnPruned, tree):
        # measured :: a -> (Int, String)
        def measured(x):
            '''Value of a tree node
               tupled with string length.
            '''
            s = ' ' + str(x) + ' '
            return len(s), s

        # lmrFromStrings :: [String] -> ([String], String, [String])
        def lmrFromStrings(xs):
            '''Lefts, Mid, Rights.'''
            i = len(xs) // 2
            ls, rs = xs[0:i], xs[i:]
            return ls, rs[0], rs[1:]

        # stringsFromLMR :: ([String], String, [String]) -> [String]
        def stringsFromLMR(lmr):
            ls, m, rs = lmr
            return ls + [m] + rs

        # fghOverLMR
        # :: (String -> String)
        # -> (String -> String)
        # -> (String -> String)
        # -> ([String], String, [String])
        # -> ([String], String, [String])
        def fghOverLMR(f, g, h):
            def go(lmr):
                ls, m, rs = lmr
                return (
                    [f(x) for x in ls],
                    g(m),
                    [h(x) for x in rs]
                )
            return lambda lmr: go(lmr)

        # leftPad :: Int -> String -> String
        def leftPad(n):
            return lambda s: (' ' * n) + s

        # treeFix :: (Char, Char, Char) -> ([String], String, [String])
        #                               ->  [String]
        def treeFix(l, m, r):
            def cfix(x):
                return lambda xs: x + xs
            return compose(stringsFromLMR)(
                fghOverLMR(cfix(l), cfix(m), cfix(r))
            )

        def lmrBuild(w, f):
            def go(wsTree):
                nChars, x = wsTree['root']
                _x = ('─' * (w - nChars)) + x
                xs = wsTree['nest']
                lng = len(xs)

                # linked :: String -> String
                def linked(s):
                    c = s[0]
                    t = s[1:]
                    return _x + '┬' + t if '┌' == c else (
                        _x + '┤' + t if '│' == c else (
                            _x + '┼' + t if '├' == c else (
                                _x + '┴' + t
                            )
                        )
                    )

                # LEAF ------------------------------------
                if 0 == lng:
                    return ([], _x, [])

                # SINGLE CHILD ----------------------------
                elif 1 == lng:
                    def lineLinked(z):
                        return _x + '─' + z
                    rightAligned = leftPad(1 + w)
                    return fghOverLMR(
                        rightAligned,
                        lineLinked,
                        rightAligned
                    )(f(xs[0]))

                # CHILDREN --------------------------------
                else:
                    rightAligned = leftPad(w)
                    lmrs = [f(x) for x in xs]
                    return fghOverLMR(
                        rightAligned,
                        linked,
                        rightAligned
                    )(
                        lmrFromStrings(
                            intercalate([] if blnCompact else ['│'])(
                                [treeFix(' ', '┌', '│')(lmrs[0])] + [
                                    treeFix('│', '├', '│')(x) for x
                                    in lmrs[1:-1]
                                ] + [treeFix('│', '└', ' ')(lmrs[-1])]
                            )
                        )
                    )
            return lambda wsTree: go(wsTree)

        measuredTree = fmapTree(measured)(tree)
        levelWidths = reduce(
            lambda a, xs: a + [max(x[0] for x in xs)],
            levels(measuredTree),
            []
        )
        treeLines = stringsFromLMR(
            foldr(lmrBuild)(None)(levelWidths)(
                measuredTree
            )
        )
        return [
            s for s in treeLines
            if any(c not in '│ ' for c in s)
        ] if (not blnCompact and blnPruned) else treeLines

    return lambda blnPruned: (
        lambda tree: '\n'.join(go(blnPruned, tree))
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Trees drawn in varying formats'''

    # tree1 :: Tree Int
    tree1 = Node(1)([
        Node(2)([
            Node(4)([
                Node(7)([])
            ]),
            Node(5)([])
        ]),
        Node(3)([
            Node(6)([
                Node(8)([]),
                Node(9)([])
            ])
        ])
    ])

    # tree :: Tree String
    tree2 = Node('Alpha')([
        Node('Beta')([
            Node('Epsilon')([]),
            Node('Zeta')([]),
            Node('Eta')([]),
            Node('Theta')([
                Node('Mu')([]),
                Node('Nu')([])
            ])
        ]),
        Node('Gamma')([
            Node('Xi')([Node('Omicron')([])])
        ]),
        Node('Delta')([
            Node('Iota')([]),
            Node('Kappa')([]),
            Node('Lambda')([])
        ])
    ])

    print(
        '\n\n'.join([
            'Fully compacted (parents not all centered):',
            drawTree2(True)(False)(
                tree1
            ),
            'Expanded with vertically centered parents:',
            drawTree2(False)(False)(
                tree2
            ),
            'Centered parents with nodeless lines pruned out:',
            drawTree2(False)(True)(
                tree2
            )
        ])
    )


# GENERIC -------------------------------------------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Contructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.
    '''
    return lambda xs: {'type': 'Tree', 'root': v, 'nest': xs}


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
    )


# fmapTree :: (a -> b) -> Tree a -> Tree b
def fmapTree(f):
    '''A new tree holding the results of
       applying f to each root in
       the existing tree.
    '''
    def go(x):
        return Node(f(x['root']))(
            [go(v) for v in x['nest']]
        )
    return lambda tree: go(tree)


# foldr :: (a -> b -> b) -> b -> [a] -> b
def foldr(f):
    '''Right to left reduction of a list,
       using the binary operator f, and
       starting with an initial accumulator value.
    '''
    def g(x, a):
        return f(a, x)
    return lambda acc: lambda xs: reduce(
        g, xs[::-1], acc
    )


# intercalate :: [a] -> [[a]] -> [a]
# intercalate :: String -> [String] -> String
def intercalate(x):
    '''The concatenation of xs
       interspersed with copies of x.
    '''
    return lambda xs: x.join(xs) if isinstance(x, str) else list(
        chain.from_iterable(
            reduce(lambda a, v: a + [x, v], xs[1:], [xs[0]])
        )
    ) if xs else []


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
    return lambda x: go(x)


# levels :: Tree a -> [[a]]
def levels(tree):
    '''A list of the nodes at each level of the tree.'''
    return list(
        map_(map_(root))(
            takewhile(
                bool,
                iterate(concatMap(nest))(
                    [tree]
                )
            )
        )
    )


# map :: (a -> b) -> [a] -> [b]
def map_(f):
    '''The list obtained by applying f
       to each element of xs.
    '''
    return lambda xs: list(map(f, xs))


# nest :: Tree a -> [Tree a]
def nest(t):
    '''Accessor function for children of tree node.'''
    return t['nest'] if 'nest' in t else None


# root :: Tree a -> a
def root(t):
    '''Accessor function for data of tree node.'''
    return t['root'] if 'root' in t else None


# MAIN ---
if __name__ == '__main__':
    main()
