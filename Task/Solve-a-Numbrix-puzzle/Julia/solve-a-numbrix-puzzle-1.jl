using .Hidato

const numbrixmoves = [[-1, 0], [0, -1], [0, 1], [1, 0]]

board, maxmoves, fixed, starts = hidatoconfigure(numbrix1)
printboard(board, " 0 ", "   ")
hidatosolve(board, maxmoves, numbrixmoves, fixed, starts[1][1], starts[1][2], 1)
printboard(board)

board, maxmoves, fixed, starts = hidatoconfigure(numbrix2)
printboard(board, " 0 ", "   ")
hidatosolve(board, maxmoves, numbrixmoves, fixed, starts[1][1], starts[1][2], 1)
printboard(board)
