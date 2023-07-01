'''Hilbert curve'''

from itertools import (chain, islice)


# hilbertCurve :: Int -> SVG String
def hilbertCurve(n):
    '''An SVG string representing a
       Hilbert curve of degree n.
    '''
    w = 1024
    return svgFromPoints(w)(
        hilbertPoints(w)(
            hilbertTree(n)
        )
    )


# hilbertTree :: Int -> Tree Char
def hilbertTree(n):
    '''Nth application of a rule to a seedling tree.'''

    # rule :: Dict Char [Char]
    rule = {
        'a': ['d', 'a', 'a', 'b'],
        'b': ['c', 'b', 'b', 'a'],
        'c': ['b', 'c', 'c', 'd'],
        'd': ['a', 'd', 'd', 'c']
    }

    # go :: Tree Char -> Tree Char
    def go(tree):
        c = tree['root']
        xs = tree['nest']
        return Node(c)(
            map(go, xs) if xs else map(
                flip(Node)([]),
                rule[c]
            )
        )
    seed = Node('a')([])
    return list(islice(
        iterate(go)(seed), n
    ))[-1] if 0 < n else seed


# hilbertPoints :: Int -> Tree Char -> [(Int, Int)]
def hilbertPoints(w):
    '''Serialization of a tree to a list of points
       bounded by a square of side w.
    '''

    # vectors :: Dict Char [(Int, Int)]
    vectors = {
        'a': [(-1, 1), (-1, -1), (1, -1), (1, 1)],
        'b': [(1, -1), (-1, -1), (-1, 1), (1, 1)],
        'c': [(1, -1), (1, 1), (-1, 1), (-1, -1)],
        'd': [(-1, 1), (1, 1), (1, -1), (-1, -1)]
    }

    # points :: Int -> ((Int, Int), Tree Char) -> [(Int, Int)]
    def points(d):
        '''Size -> Centre of a Hilbert subtree -> All subtree points
        '''
        def go(xy, tree):
            r = d // 2

            def deltas(v):
                return (
                    xy[0] + (r * v[0]),
                    xy[1] + (r * v[1])
                )
            centres = map(deltas, vectors[tree['root']])
            return chain.from_iterable(
                map(points(r), centres, tree['nest'])
            ) if tree['nest'] else centres
        return go

    d = w // 2
    return lambda tree: list(points(d)((d, d), tree))


# svgFromPoints :: Int -> [(Int, Int)] -> SVG String
def svgFromPoints(w):
    '''Width of square canvas -> Point list -> SVG string'''

    def go(xys):
        def points(xy):
            return str(xy[0]) + ' ' + str(xy[1])
        xs = ' '.join(map(points, xys))
        return '\n'.join(
            ['<svg xmlns="http://www.w3.org/2000/svg"',
             f'width="512" height="512" viewBox="5 5 {w} {w}">',
             f'<path d="M{xs}" ',
             'stroke-width="2" stroke="red" fill="transparent"/>',
             '</svg>'
             ]
        )
    return go


# ------------------------- TEST --------------------------
def main():
    '''Testing generation of the SVG for a Hilbert curve'''
    print(
        hilbertCurve(6)
    )


# ------------------- GENERIC FUNCTIONS -------------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Contructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.'''
    return lambda xs: {'type': 'Node', 'root': v, 'nest': xs}


# flip :: (a -> b -> c) -> b -> a -> c
def flip(f):
    '''The (curried or uncurried) function f with its
       arguments reversed.
    '''
    return lambda a: lambda b: f(b)(a)


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


#  TEST ---------------------------------------------------
if __name__ == '__main__':
    main()
