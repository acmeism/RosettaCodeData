#  Solve No Connection Puzzle
#
#  Nigel_Galloway
#  October 6th., 2014
require 'HLPSolver'
ADJACENT = [[0,0]]
A,B,C,D,E,F,G,H = [0,1],[0,2],[1,0],[1,1],[1,2],[1,3],[2,1],[2,2]

board1 = <<EOS
  . 0 0 .
  0 0 1 0
  . 0 0 .

EOS
g = HLPsolver.new(board1)
g.board[A[0]][A[1]].adj = [B,G,H,F]
g.board[B[0]][B[1]].adj = [A,C,G,H]
g.board[C[0]][C[1]].adj = [B,E,F,H]
g.board[D[0]][D[1]].adj = [F]
g.board[E[0]][E[1]].adj = [C]
g.board[F[0]][F[1]].adj = [A,C,D,G]
g.board[G[0]][G[1]].adj = [A,B,F,H]
g.board[H[0]][H[1]].adj = [A,B,C,G]
g.solve
