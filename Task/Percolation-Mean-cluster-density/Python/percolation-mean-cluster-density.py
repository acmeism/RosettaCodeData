from __future__ import division
from random import random
import string
from math import fsum

n_range, p, t = (2**n2 for n2 in range(4, 14, 2)), 0.5, 5
N = M = 15

NOT_CLUSTERED = 1   # filled but not clustered cell
cell2char = ' #' + string.ascii_letters

def newgrid(n, p):
    return [[int(random() < p) for x in range(n)] for y in range(n)]

def pgrid(cell):
    for n in range(N):
        print( '%i)  ' % (n % 10)
               + ' '.join(cell2char[cell[n][m]] for m in range(M)))


def cluster_density(n, p):
    cc = clustercount(newgrid(n, p))
    return cc / n / n

def clustercount(cell):
    walk_index = 1
    for n in range(N):
        for m in range(M):
            if cell[n][m] == NOT_CLUSTERED:
                walk_index += 1
                walk_maze(m, n, cell, walk_index)
    return walk_index - 1


def walk_maze(m, n, cell, indx):
    # fill cell
    cell[n][m] = indx
    # down
    if n < N - 1 and cell[n+1][m] == NOT_CLUSTERED:
        walk_maze(m, n+1, cell, indx)
    # right
    if m < M - 1 and cell[n][m + 1] == NOT_CLUSTERED:
        walk_maze(m+1, n, cell, indx)
    # left
    if m and cell[n][m - 1] == NOT_CLUSTERED:
        walk_maze(m-1, n, cell, indx)
    # up
    if n and cell[n-1][m] == NOT_CLUSTERED:
        walk_maze(m, n-1, cell, indx)


if __name__ == '__main__':
    cell = newgrid(n=N, p=0.5)
    print('Found %i clusters in this %i by %i grid\n'
          % (clustercount(cell), N, N))
    pgrid(cell)
    print('')

    for n in n_range:
        N = M = n
        sim = fsum(cluster_density(n, p) for i in range(t)) / t
        print('t=%3i p=%4.2f n=%5i sim=%7.5f'
              % (t, p, n, sim))
