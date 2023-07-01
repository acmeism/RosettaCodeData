"""
Given a %i by %i sqare array of zeroes or ones in an initial
configuration, and a target configuration of zeroes and ones
The task is to transform one to the other in as few moves as
possible by inverting whole numbered rows or whole lettered
columns at once.
In an inversion any 1 becomes 0 and any 0 becomes 1 for that
whole row or column.

"""

from random import randrange
from copy import deepcopy
from string import ascii_lowercase


try:    # 2to3 fix
    input = raw_input
except:
    pass

N = 3   # N x N Square arrray

board  = [[0]* N for i in range(N)]

def setbits(board, count=1):
    for i in range(count):
        board[randrange(N)][randrange(N)] ^= 1

def shuffle(board, count=1):
    for i in range(count):
        if randrange(0, 2):
            fliprow(randrange(N))
        else:
            flipcol(randrange(N))


def pr(board, comment=''):
    print(str(comment))
    print('     ' + ' '.join(ascii_lowercase[i] for i in range(N)))
    print('  ' + '\n  '.join(' '.join(['%2s' % j] + [str(i) for i in line])
                             for j, line in enumerate(board, 1)))

def init(board):
    setbits(board, count=randrange(N)+1)
    target = deepcopy(board)
    while board == target:
        shuffle(board, count=2 * N)
    prompt = '  X, T, or 1-%i / %s-%s to flip: ' % (N, ascii_lowercase[0],
                                                    ascii_lowercase[N-1])
    return target, prompt

def fliprow(i):
    board[i-1][:] = [x ^ 1 for x in board[i-1] ]

def flipcol(i):
    for row in board:
        row[i] ^= 1

if __name__ == '__main__':
    print(__doc__ % (N, N))
    target, prompt = init(board)
    pr(target, 'Target configuration is:')
    print('')
    turns = 0
    while board != target:
        turns += 1
        pr(board, '%i:' % turns)
        ans = input(prompt).strip()
        if (len(ans) == 1
            and ans in ascii_lowercase and ascii_lowercase.index(ans) < N):
            flipcol(ascii_lowercase.index(ans))
        elif ans and all(ch in '0123456789' for ch in ans) and 1 <= int(ans) <= N:
            fliprow(int(ans))
        elif ans == 'T':
            pr(target, 'Target configuration is:')
            turns -= 1
        elif ans == 'X':
            break
        else:
            print("  I don't understand %r... Try again. "
                  "(X to exit or T to show target)\n" % ans[:9])
            turns -= 1
    else:
        print('\nWell done!\nBye.')
