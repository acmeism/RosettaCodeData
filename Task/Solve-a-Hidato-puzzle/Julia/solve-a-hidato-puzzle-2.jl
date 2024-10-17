using .Hidato

hidat = """
__ 33 35 __ __  .  .  .
__ __ 24 22 __  .  .  .
__ __ __ 21 __ __  .  .
__ 26 __ 13 40 11  .  .
27 __ __ __  9 __  1  .
 .  . __ __ 18 __ __  .
 .  .  .  . __  7 __ __
 .  .  .  .  .  .  5 __"""

const kingmoves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

board, maxmoves, fixed, starts = hidatoconfigure(hidat)
printboard(board)
hidatosolve(board, maxmoves, kingmoves, fixed, starts[1][1], starts[1][2], 1)
printboard(board)
