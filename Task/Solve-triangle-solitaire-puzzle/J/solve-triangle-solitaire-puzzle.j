NB. This is a direct translation of the python program,
NB. except for the display which by move is horizontal.

PEGS =: >:i.15

move =: 4 : 0       NB. move should have been factored in the 2014-NOV-29 python version
 board =. x
 'peg over land' =. y
 board =. board RemovePeg peg
 board =. board RemovePeg over
 board =. board AddPeg land
)

NB.# Draw board triangle in ascii
NB.#
NB.def DrawBoard(board):
NB.  peg = [0,]*16
NB.  for n in xrange(1,16):
NB.    peg[n] = '.'
NB.    if n in board:
NB.      peg[n] = "%X" % n
NB.  print "     %s" % peg[1]
NB.  print "    %s %s" % (peg[2],peg[3])
NB.  print "   %s %s %s" % (peg[4],peg[5],peg[6])
NB.  print "  %s %s %s %s" % (peg[7],peg[8],peg[9],peg[10])
NB.  print " %s %s %s %s %s" % (peg[11],peg[12],peg[13],peg[14],peg[15])

HEXCHARS =: Num_j_ , Alpha_j_

DrawBoard =: 3 : 0
 NB. observe 1 1 0 1 0 0 1 0 0 0 1 0 0 0 0 -: 2#.inv 26896  (== 6910 in base 16)
 board =. y
 < (-i._5) (|."0 1) 1j1 (#"1) (2#.inv 16b6910)[;.1 }. (board { HEXCHARS) board } 16 # '.'
)


NB.# remove peg n from board
NB.def RemovePeg(board,n):
NB.  board.remove(n)
NB.  return board

RemovePeg =: i. ({. , (}.~ >:)~) [


NB.# Add peg n on board
NB.def AddPeg(board,n):
NB.  board.append(n)
NB.  return board

AddPeg =: ,


NB.# return true if peg N is on board else false is empty position
NB.def IsPeg(board,n):
NB.  return n in board

IsPeg =: e.~


NB.# A dictionary of valid jump moves index by jumping peg
NB.# then a list of moves where move has jumpOver and LandAt positions
NB.JumpMoves = { 1: [ (2,4),(3,6) ],  # 1 can jump over 2 to land on 4, or jumper over 3 to land on 6
NB.              2: [ (4,7),(5,9)  ],
NB.              3: [ (5,8),(6,10) ],
NB.                 ...
NB.             14: [ (9,5),(13,12)  ],
NB.             15: [ (10,6),(14,13) ]
NB.            }

JumpMoves =: a:,(<@:([\~ _2:)@:".;._2) 0 :0  NB. 1 can jump over 2 to land on 4, or jump over 3 to land on 6
   (2,4),(3,6)
   (4,7),(5,9)
   (5,8),(6,10)
   (2,1),(5,6),(7,11),(8,13)
   (8,12),(9,14)
   (3,1),(5,4),(9,13),(10,15)
   (4,2),(8,9)
   (5,3),(9,10)
   (5,2),(8,7)
   (9,8)
   (12,13)
   (8,5),(13,14)
   (8,4),(9,6),(12,11),(14,15)
   (9,5),(13,12)
   (10,6),(14,13)
)


NB.Solution = []
NB.#
NB.# Recursively solve the problem
NB.#
NB.def Solve(board):
NB.  #DrawBoard(board)
NB.  if len(board) == 1:
NB.    return board # Solved one peg left
NB.  # try a move for each peg on the board
NB.  for peg in xrange(1,16): # try in numeric order not board order
NB.    if IsPeg(board,peg):
NB.      movelist = JumpMoves[peg]
NB.      for over,land in movelist:
NB.        if IsPeg(board,over) and not IsPeg(board,land):
NB.          saveboard = board[:] # for back tracking
NB.          board = RemovePeg(board,peg)
NB.          board = RemovePeg(board,over)
NB.          board = AddPeg(board,land) # board order changes!
NB.          Solution.append((peg,over,land))
NB.          board = Solve(board)
NB.          if len(board) == 1:
NB.            return board
NB.        ## undo move and back track when stuck!
NB.          board = saveboard[:] # back track
NB.          del Solution[-1] # remove last move
NB.  return board

Solution =: 0 3 $ 0

Solve =: 3 : 0
 board =. y
 if. 1 = # board do. return. end.
 for_peg. PEGS do.
  if. board IsPeg peg do.
   movelist =: peg {:: JumpMoves
   for_OL. movelist do.
    'over land' =. OL
    if. (board IsPeg over) (*. -.) (board IsPeg land) do.
     saveboard =. board          NB. for back tracking
     board =. board move peg,over,land
     Solution =: Solution , peg, over, land
     board =. Solve board
     if. 1 = # board do. return. end.
     board =. saveboard
     Solution =: }: Solution
    end.
   end.
  end.
 end.
 board
)


NB.#
NB.# Remove one peg and start solving
NB.#
NB.def InitSolve(empty):
NB.  board = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
NB.  RemovePeg(board,empty_start)
NB.  Solve(board)

InitSolve =: [: Solve PEGS RemovePeg ]


NB.#
NB.empty_start = 1
NB.InitSolve(empty_start)

InitSolve empty_start =: 1


NB.board = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
NB.RemovePeg(board,empty_start)
NB.for peg,over,land in Solution:
NB.  RemovePeg(board,peg)
NB.  RemovePeg(board,over)
NB.  AddPeg(board,land) # board order changes!
NB.  DrawBoard(board)
NB.  print "Peg %X jumped over %X to land on %X\n" % (peg,over,land)


(3 : 0) PEGS RemovePeg empty_start
 board =. y
 horizontal =. DrawBoard board
 for_POL. Solution do.
  'peg over land' =. POL
  board =. board move POL
  horizontal =. horizontal , DrawBoard board
  smoutput 'Peg ',(":peg),' jumped over ',(":over),' to land on ',(":land)
 end.
 smoutput horizontal
 NB. Solution NB. return Solution however Solution is global.
)
