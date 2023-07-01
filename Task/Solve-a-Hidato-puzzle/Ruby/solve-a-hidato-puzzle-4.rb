require 'HLPsolver'

ADJACENT = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

# solve Evil Case 1:
board1 = <<EOS
  .  4
  0  7  0
  1  0  0
EOS
HLPsolver.new(board1).solve

boardx = <<EOS
  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0
  0  1  0  0  0  0  0  0
  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0
  0  0  0  0  0  0  0  0
EOS
HLPsolver.new(boardx).solve

# solve this tasks example:
board2 = <<EOS
  0 33 35  0  0
  0  0 24 22  0
  0  0  0 21  0  0
  0 26  0 13 40 11
 27  0  0  0  9  0  1
  .  .  0  0 18  0  0
  .  .  .  .  0  7  0  0
  .  .  .  .  .  .  5  0
EOS
HLPsolver.new(board2).solve

#solve The Snake in the Grass:
board3 = <<EOS
  1  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  . 74
  .  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .  0  .
  .  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .  .  0  0  .
EOS
t0 = Time.now
HLPsolver.new(board3).solve
puts " #{Time.now - t0} sec"
