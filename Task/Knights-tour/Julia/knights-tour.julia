using .Hidato       # Note that the . here means to look locally for the module rather than in the libraries

const chessboard = """
 0 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0 """

const knightmoves = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]

board, maxmoves, fixed, starts = hidatoconfigure(chessboard)
printboard(board, " 0", "  ")
hidatosolve(board, maxmoves, knightmoves, fixed, starts[1][1], starts[1][2], 1)
printboard(board)
