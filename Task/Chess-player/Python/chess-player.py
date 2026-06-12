# Simple Python chess engine
# Computer plays Black

import sys, random, chess
from collections import Counter

UNICODE  = True     # Print board with Unicode symbols?
DARKMODE = False    # Invert symbol colors?
RANDFAC  = 1        # Randomness factor

board = chess.Board()

def hal9000():
    print("Thank you for a very enjoyable game.")

def pboard():
    "Print board"
    if UNICODE and DARKMODE:
        print(board.unicode(invert_color=True))
    elif UNICODE:
        print(board.unicode())
    else:
        print(board)
pboard()

while not board.outcome():
    while True:
        try:
            move = input("Your move? ")
            if move in ("q", "quit", "resign", "exit"):
                hal9000()
                sys.exit()
            board.push_uci(move)
        except ValueError: print("Sorry?")
        else: break

    moves = {}
    for mymove in board.legal_moves:
        board.push(mymove)
        if board.result() == "0-1": # Can Black win? If so, end the game.
            print(mymove)
            pboard()
            print("I'm sorry, Frank. I think you missed it:")
            pm = board.peek()
            pn = chess.piece_name(board.piece_at(pm.to_square).piece_type)
            ps = chess.square_name(pm.to_square)
            print(f"{pn.capitalize()} to {ps}, mate.")
            hal9000()
            sys.exit()

        for yourmove in board.legal_moves:
            board.push(yourmove)
            if board.result() == "1-0": # Has White won? If so, avoid move.
                board.pop()
                moves[mymove] = -1000
                break
            v = Counter(board.fen().split()[0])
            p = (9 * (v['q']-v['Q']) + 5 * (v['r']-v['R']) + 3 * (v['b']-v['B'])
                + 3 * (v['n']-v['N']) + v['p'] - v['P'])
            mobility = len(list(board.legal_moves)) + RANDFAC * random.random()
            p += mobility / 1000
            #print(mymove, yourmove, p)
            old = moves.get(mymove, 1e6)
            if p < old: moves[mymove] = p
            board.pop()
        board.pop()
    try: sel = sorted(moves.items(), key=lambda item: -item[1])[0][0]
    except: break
    print(sel)
    board.push(sel)
    pboard()

print(f"Game finished, result is {board.result()}")
hal9000()
