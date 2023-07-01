require 'HLPsolver'

ADJACENT = [[-1,-2],[-2,-1],[-2,1],[-1,2],[1,2],[2,1],[2,-1],[1,-2]]

boardy = <<EOS
. . 0 0 0
. . 0 . 0 0
. 0 0 0 0 0 0 0
0 0 0 . . 0 . 0
0 . 0 . . 0 0 0
1 0 0 0 0 0 0
. . 0 0 . 0
. . . 0 0 0
EOS
t0 = Time.now
HLPsolver.new(boardy).solve
puts " #{Time.now - t0} sec"
