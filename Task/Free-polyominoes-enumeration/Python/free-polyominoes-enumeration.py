from itertools import imap, imap, groupby, chain, imap
from operator import itemgetter
from sys import argv
from array import array

def concat_map(func, it):
    return list(chain.from_iterable(imap(func, it)))

def minima(poly):
    """Finds the min x and y coordiate of a Polyomino."""
    return (min(pt[0] for pt in poly), min(pt[1] for pt in poly))

def translate_to_origin(poly):
    (minx, miny) = minima(poly)
    return [(x - minx, y - miny) for (x, y) in poly]

rotate90   = lambda (x, y): ( y, -x)
rotate180  = lambda (x, y): (-x, -y)
rotate270  = lambda (x, y): (-y,  x)
reflect    = lambda (x, y): (-x,  y)

def rotations_and_reflections(poly):
    """All the plane symmetries of a rectangular region."""
    return (poly,
            map(rotate90, poly),
            map(rotate180, poly),
            map(rotate270, poly),
            map(reflect, poly),
            [reflect(rotate90(pt)) for pt in poly],
            [reflect(rotate180(pt)) for pt in poly],
            [reflect(rotate270(pt)) for pt in poly])

def canonical(poly):
    return min(sorted(translate_to_origin(pl)) for pl in rotations_and_reflections(poly))

def unique(lst):
    lst.sort()
    return map(next, imap(itemgetter(1), groupby(lst)))

# All four points in Von Neumann neighborhood.
contiguous = lambda (x, y): [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]

def new_points(poly):
    """Finds all distinct points that can be added to a Polyomino."""
    return unique([pt for pt in concat_map(contiguous, poly) if pt not in poly])

def new_polys(poly):
    return unique([canonical(poly + [pt]) for pt in new_points(poly)])

monomino = [(0, 0)]
monominoes = [monomino]

def rank(n):
    """Generates polyominoes of rank n recursively."""
    assert n >= 0
    if n == 0: return []
    if n == 1: return monominoes
    return unique(concat_map(new_polys, rank(n - 1)))

def text_representation(poly):
    """Generates a textual representation of a Polyomino."""
    min_pt = minima(poly)
    max_pt = (max(p[0] for p in poly), max(p[1] for p in poly))
    table = [array('c', ' ') * (max_pt[1] - min_pt[1] + 1)
             for _ in xrange(max_pt[0] - min_pt[0] + 1)]
    for pt in poly:
        table[pt[0] - min_pt[0]][pt[1] - min_pt[1]] = '#'
    return "\n".join(row.tostring() for row in table)

def main():
    print [len(rank(n)) for n in xrange(1, 11)]

    n = int(argv[1]) if (len(argv) == 2) else 5
    print "\nAll free polyominoes of rank %d:" % n

    for poly in rank(n):
        print text_representation(poly), "\n"

main()
