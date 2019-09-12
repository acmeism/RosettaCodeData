'''Tree traversals'''

from itertools import (chain, takewhile)
from functools import (reduce)
from operator import (mul)


# foldTree :: (a -> [b] -> b) -> Tree a -> b
def foldTree(f):
    '''The catamorphism on trees.
       A summary value derived by a depth-first fold.'''
    def go(node):
        return f(root(node))(
            list(map(go, nest(node)))
        )
    return lambda tree: go(tree)


# levels :: Tree a -> [[a]]
def levels(tree):
    '''A list of the nodes at each level of the tree.'''
    fmap = curry(map)
    return list(fmap(fmap(root))(
        takewhile(
            bool,
            iterate(concatMap(nest))([tree])
        )
    ))


# preorder :: a -> [[a]] -> [a]
def preorder(x):
    '''This node followed by the rest.'''
    return lambda xs: [x] + concat(xs)


# inorder :: a -> [[a]] -> [a]
def inorder(x):
    '''Descendants of any first child,
       then this node, then the rest.'''
    return lambda xs: (
        xs[0] + [x] + concat(xs[1:]) if xs else [x]
    )


# postorder :: a -> [[a]] -> [a]
def postorder(x):
    '''Descendants first, then this node.'''
    return lambda xs: concat(xs) + [x]


# levelorder :: Tree a -> [a]
def levelorder(tree):
    '''Top-down concatenation of this node
       with the rows below.'''
    return concat(levels(tree))


# treeSum :: Tree Int -> Int
def treeSum(x):
    '''This node's value + the sum of its descendants.'''
    return lambda xs: x + sum(xs)


# treeSum :: Tree Int -> Int
def treeProduct(x):
    '''This node's value * the product of its descendants.'''
    return lambda xs: x * numericProduct(xs)


# treeMax :: Tree Int -> Int
def treeMax(x):
    '''Maximum value of this node and any descendants.'''
    return lambda xs: max([x] + xs)


# treeMin :: Tree Int -> Int
def treeMin(x):
    '''Minimum value of this node and any descendants.'''
    return lambda xs: min([x] + xs)


# nodeCount :: Tree a -> Int
def nodeCount(_):
    '''One more than the total number of descendants.'''
    return lambda xs: 1 + sum(xs)


# treeWidth :: Tree a -> Int
def treeWidth(_):
    '''Sum of widths of any children, or a minimum of 1.'''
    return lambda xs: sum(xs) if xs else 1


# treeDepth :: Tree a -> Int
def treeDepth(_):
    '''One more than that of the deepest child.'''
    return lambda xs: 1 + (max(xs) if xs else 0)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Tree traversals - accumulating and folding'''

    # tree :: Tree Int
    tree = Node(1)([
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

    print(
        fTable(main.__doc__ + ':\n')(fName)(str)(
            lambda f: (
                foldTree(f) if 'levelorder' != fName(f) else f
            )(tree)
        )([
            preorder, inorder, postorder, levelorder,
            treeSum, treeProduct, treeMin, treeMax,
            nodeCount, treeWidth, treeDepth
        ])
    )


# GENERIC -------------------------------------------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Contructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.'''
    return lambda xs: {'type': 'Node', 'root': v, 'nest': xs}


# nest :: Tree a -> [Tree a]
def nest(tree):
    '''Accessor function for children of tree node'''
    return tree['nest'] if 'nest' in tree else None


# root :: Dict -> a
def root(tree):
    '''Accessor function for data of tree node'''
    return tree['root'] if 'root' in tree else None


# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xxs):
    '''The concatenation of all the elements in a list.'''
    xs = list(chain.from_iterable(xxs))
    unit = '' if isinstance(xs, str) else []
    return unit if not xs else (
        ''.join(xs) if isinstance(xs[0], str) else xs
    )


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''Concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output a in list,
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    '''A curried function derived
       from an uncurried function.'''
    return lambda a: lambda b: f(a, b)


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated applications of f to x.'''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return lambda x: go(x)


# numericProduct :: [Num] -> Num
def numericProduct(xs):
    '''The arithmetic product of all numbers in xs.'''
    return reduce(mul, xs, 1)


# FORMATTING ----------------------------------------------

# fName :: (a -> b) -> String
def fName(f):
    '''The name bound to the function.'''
    return f.__name__


# fTable :: String -> (a -> String) ->
#                     (b -> String) -> (a -> b) -> [a] -> String
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


if __name__ == '__main__':
    main()
