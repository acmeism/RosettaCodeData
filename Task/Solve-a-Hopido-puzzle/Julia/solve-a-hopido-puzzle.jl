using .Hidato       # Note that the . here means to look locally for the module rather than in the libraries

const hopid = """
 . 0 0 . 0 0 .
 0 0 0 0 0 0 0
 0 0 0 0 0 0 0
 . 0 0 0 0 0 .
 . . 0 0 0 . .
 . . . 0 . . . """

const hopidomoves = [[-3, 0], [0, -3], [-2, -2], [-2, 2], [2, -2], [0, 3], [3, 0], [2, 2]]

board, maxmoves, fixed, starts = hidatoconfigure(hopid)
printboard(board, " 0", "  ")
hidatosolve(board, maxmoves, hopidomoves, fixed, starts[1][1], starts[1][2], 1)
printboard(board)
