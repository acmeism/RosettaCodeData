'''
    Tic-tac-toe game player.
    Input the index of where you wish to place your mark at your turn.
'''

import random

board = list('123456789')
wins = ((0,1,2), (3,4,5), (6,7,8),
        (0,3,6), (1,4,7), (2,5,8),
        (0,4,8), (2,4,6))

def printboard():
    print('\n-+-+-\n'.join('|'.join(board[x:x+3]) for x in(0,3,6)))

def score(board=board):
    for w in wins:
        b = board[w[0]]
        if b in 'XO' and all (board[i] == b for i in w):
            return b, [i+1 for i in w]
    return None

def finished():
    return all (b in 'XO' for b in board)

def space(board=board):
    return [ b for b in board if b not in 'XO']

def my_turn(xo, board):
    options = space()
    choice = random.choice(options)
    board[int(choice)-1] = xo
    return choice

def my_better_turn(xo, board):
    'Will return a next winning move or block your winning move if possible'
    ox = 'O' if xo =='X' else 'X'
    oneblock = None
    options  = [int(s)-1 for s in space(board)]
    for choice in options:
        brd = board[:]
        brd[choice] = xo
        if score(brd):
            break
        if oneblock is None:
            brd[choice] = ox
            if score(brd):
                oneblock = choice
    else:
        choice = oneblock if oneblock is not None else random.choice(options)
    board[choice] = xo
    return choice+1

def your_turn(xo, board):
    options = space()
    while True:
        choice = input("\nPut your %s in any of these positions: %s "
                       % (xo, ''.join(options))).strip()
        if choice in options:
            break
        print( "Whoops I don't understand the input" )
    board[int(choice)-1] = xo
    return choice

def me(xo='X'):
    printboard()
    print('\nI go at', my_better_turn(xo, board))
    return score()

def you(xo='O'):
    printboard()
    # Call my_turn(xo, board) below for it to play itself
    print('\nYou went at', your_turn(xo, board))
    return score()


print(__doc__)
while not finished():
    s = me('X')
    if s:
        printboard()
        print("\n%s wins along %s" % s)
        break
    if not finished():
        s = you('O')
        if s:
            printboard()
            print("\n%s wins along %s" % s)
            break
else:
    print('\nA draw')
