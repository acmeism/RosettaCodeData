'''Visualize a tree'''

from itertools import (repeat, starmap)
from operator import (add)


# drawTree :: Tree a -> String
def drawTree(tree):
    '''ASCII diagram of a tree.'''
    return '\n'.join(draw(tree))


# draw :: Tree a -> [String]
def draw(node):
    '''List of the lines of an ASCII
       diagram of a tree.'''
    def shift(first, other, xs):
        return list(starmap(
            add,
            zip(
                [first] + list(
                    repeat(other, len(xs) - 1)
                ),
                xs
            )
        ))

    def drawSubTrees(xs):
        return (
            (
                ['│'] + shift(
                    '├─ ', '│  ', draw(xs[0])
                ) + drawSubTrees(xs[1:])
            ) if 1 < len(xs) else ['│'] + shift(
                '└─ ', '   ', draw(xs[0])
            )
        ) if xs else []

    return (str(root(node))).splitlines() + (
        drawSubTrees(nest(node))
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''

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

    print(drawTree(tree))


# GENERIC -------------------------------------------------


# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Contructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.'''
    return lambda xs: {'type': 'Node', 'root': v, 'nest': xs}


# nest :: Tree a -> [Tree a]
def nest(tree):
    '''Accessor function for children of tree node.'''
    return tree['nest'] if 'nest' in tree else None


# root :: Dict -> a
def root(dct):
    '''Accessor function for data of tree node.'''
    return dct['root'] if 'root' in dct else None


# MAIN ---
if __name__ == '__main__':
    main()
