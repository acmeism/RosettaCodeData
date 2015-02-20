from collections import namedtuple
from random import random
from pprint import pprint as pp

Grid = namedtuple('Grid', 'cell, hwall, vwall')

M, N, t = 10, 10, 100

class PercolatedException(Exception): pass

HVF = [(' .', ' _'), (':', '|'), (' ', '#')]  # Horiz, vert, fill chars

def newgrid(p):
    hwall = [[int(random() < p) for m in range(M)]
             for n in range(N+1)]
    vwall = [[(1 if m in (0, M) else int(random() < p)) for m in range(M+1)]
             for n in range(N)]
    cell = [[0 for m in range(M)]
             for n in range(N)]
    return Grid(cell, hwall, vwall)

def pgrid(grid, percolated=None):
    cell, hwall, vwall = grid
    h, v, f = HVF
    for n in range(N):
        print('    ' + ''.join(h[hwall[n][m]] for m in range(M)))
        print('%i)  ' % (n % 10) + ''.join(v[vwall[n][m]] + f[cell[n][m] if m < M else 0]
                                          for m in range(M+1))[:-1])
    n = N
    print('    ' + ''.join(h[hwall[n][m]] for m in range(M)))
    if percolated:
        where = percolated.args[0][0]
        print('!)  ' + '  ' * where + ' ' + f[1])

def pour_on_top(grid):
    cell, hwall, vwall = grid
    n = 0
    try:
        for m in range(M):
            if not hwall[n][m]:
                flood_fill(m, n, cell, hwall, vwall)
    except PercolatedException as ex:
        return ex
    return None


def flood_fill(m, n, cell, hwall, vwall):
    # fill cell
    cell[n][m] = 1
    # bottom
    if n < N - 1 and not hwall[n + 1][m] and not cell[n+1][m]:
        flood_fill(m, n+1, cell, hwall, vwall)
    # THE bottom
    elif n == N - 1 and not hwall[n + 1][m]:
        raise PercolatedException((m, n+1))
    # left
    if m and not vwall[n][m] and not cell[n][m - 1]:
        flood_fill(m-1, n, cell, hwall, vwall)
    # right
    if m < M - 1 and not vwall[n][m + 1] and not cell[n][m + 1]:
        flood_fill(m+1, n, cell, hwall, vwall)
    # top
    if n and not hwall[n][m] and not cell[n-1][m]:
        flood_fill(m, n-1, cell, hwall, vwall)

if __name__ == '__main__':
    sample_printed = False
    pcount = {}
    for p10 in range(11):
        p = (10 - p10) / 10.0    # count down so sample print is interesting
        pcount[p] = 0
        for tries in range(t):
            grid = newgrid(p)
            percolated = pour_on_top(grid)
            if percolated:
                pcount[p] += 1
                if not sample_printed:
                    print('\nSample percolating %i x %i grid' % (M, N))
                    pgrid(grid, percolated)
                    sample_printed = True
    print('\n p: Fraction of %i tries that percolate through' % t )

    pp({p:c/float(t) for p, c in pcount.items()})
