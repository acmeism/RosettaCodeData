using .Hidato       # Note that the . here means to look locally for the module rather than in the libraries

const numbrix1 = """
 0  0  0  0  0  0  0  0  0
 0  0 46 45  0 55 74  0  0
 0 38  0  0 43  0  0 78  0
 0 35  0  0  0  0  0 71  0
 0  0 33  0  0  0 59  0  0
 0 17  0  0  0  0  0 67  0
 0 18  0  0 11  0  0 64  0
 0  0 24 21  0  1  2  0  0
 0  0  0  0  0  0  0  0  0 """

const numbrix2 = """
 0  0  0  0  0  0  0  0  0
 0 11 12 15 18 21 62 61  0
 0  6  0  0  0  0  0 60  0
 0 33  0  0  0  0  0 57  0
 0 32  0  0  0  0  0 56  0
 0 37  0  1  0  0  0 73  0
 0 38  0  0  0  0  0 72  0
 0 43 44 47 48 51 76 77  0
 0  0  0  0  0  0  0  0  0 """

const numbrixmoves = [[-1, 0], [0, -1], [0, 1], [1, 0]]

board, maxmoves, fixed, starts = hidatoconfigure(numbrix1)
printboard(board, " 0 ", "   ")
hidatosolve(board, maxmoves, numbrixmoves, fixed, starts[1][1], starts[1][2], 1)
printboard(board)

board, maxmoves, fixed, starts = hidatoconfigure(numbrix2)
printboard(board, " 0 ", "   ")
hidatosolve(board, maxmoves, numbrixmoves, fixed, starts[1][1], starts[1][2], 1)
printboard(board)
