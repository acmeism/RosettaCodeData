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
    print('\n'.join(' '.join(board[x:x+3]) for x in(0,3,6)))

def score():
    for w in wins:
        b = board[w[0]]
        if b in 'XO' and all (board[i] == b for i in w):
            return b, [i+1 for i in w]
    return None, None

def finished():
    return all (b in 'XO' for b in board)

def space():
    return [ b for b in board if b not in 'XO']

def my_turn(xo):
    options = space()
    choice = random.choice(options)
    board[int(choice)-1] = xo
    return choice

def your_turn(xo):
    options = space()
    while True:
        choice = input(" Put your %s in any of these positions: %s "
                       % (xo, ''.join(options))).strip()
        if choice in options:
            break
        print( "Whoops I don't understand the input" )
    board[int(choice)-1] = xo
    return choice

def me(xo='X'):
    printboard()
    print('I go at', my_turn(xo))
    return score()
    assert not s[0], "\n%s wins across %s" % s

def you(xo='O'):
    printboard()
    # Call my_turn(xo) below for it to play itself
    print('You went at', your_turn(xo))
    return score()
    assert not s[0], "\n%s wins across %s" % s


print(__doc__)
while not finished():
    s = me('X')
    if s[0]:
        printboard()
        print("\n%s wins across %s" % s)
        break
    if not finished():
        s = you('O')
        if s[0]:
            printboard()
            print("\n%s wins across %s" % s)
            break
else:
    print('\nA draw')
