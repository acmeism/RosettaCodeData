from random import random
import string
from pprint import pprint as pp

M, N, t = 15, 15, 100

cell2char = ' #' + string.ascii_letters
NOT_VISITED = 1     # filled cell not walked

class PercolatedException(Exception): pass

def newgrid(p):
    return [[int(random() < p) for m in range(M)] for n in range(N)] # cell

def pgrid(cell, percolated=None):
    for n in range(N):
        print( '%i)  ' % (n % 10)
               + ' '.join(cell2char[cell[n][m]] for m in range(M)))
    if percolated:
        where = percolated.args[0][0]
        print('!)  ' + '  ' * where + cell2char[cell[n][where]])

def check_from_top(cell):
    n, walk_index = 0, 1
    try:
        for m in range(M):
            if cell[n][m] == NOT_VISITED:
                walk_index += 1
                walk_maze(m, n, cell, walk_index)
    except PercolatedException as ex:
        return ex
    return None


def walk_maze(m, n, cell, indx):
    # fill cell
    cell[n][m] = indx
    # down
    if n < N - 1 and cell[n+1][m] == NOT_VISITED:
        walk_maze(m, n+1, cell, indx)
    # THE bottom
    elif n == N - 1:
        raise PercolatedException((m, indx))
    # left
    if m and cell[n][m - 1] == NOT_VISITED:
        walk_maze(m-1, n, cell, indx)
    # right
    if m < M - 1 and cell[n][m + 1] == NOT_VISITED:
        walk_maze(m+1, n, cell, indx)
    # up
    if n and cell[n-1][m] == NOT_VISITED:
        walk_maze(m, n-1, cell, indx)

if __name__ == '__main__':
    sample_printed = False
    pcount = {}
    for p10 in range(11):
        p = p10 / 10.0
        pcount[p] = 0
        for tries in range(t):
            cell = newgrid(p)
            percolated = check_from_top(cell)
            if percolated:
                pcount[p] += 1
                if not sample_printed:
                    print('\nSample percolating %i x %i, p = %5.2f grid\n' % (M, N, p))
                    pgrid(cell, percolated)
                    sample_printed = True
    print('\n p: Fraction of %i tries that percolate through\n' % t )

    pp({p:c/float(t) for p, c in pcount.items()})
