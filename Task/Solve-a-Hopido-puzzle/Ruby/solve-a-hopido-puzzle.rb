require 'HLPsolver'

ADJACENT = [[-3, 0], [0, -3], [0, 3], [3, 0], [-2, -2], [-2, 2], [2, -2], [2, 2]]

board1 = <<EOS
. 0 0 . 0 0 .
0 0 0 0 0 0 0
0 0 0 0 0 0 0
. 0 0 0 0 0 .
. . 0 0 0 . .
. . . 1 . . .
EOS
t0 = Time.now
HLPsolver.new(board1).solve
puts " #{Time.now - t0} sec"
