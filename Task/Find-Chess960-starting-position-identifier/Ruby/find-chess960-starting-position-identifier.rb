CHESS_PIECES = %w<♖♘♗♕♔ ♜♞♝♛♚>
def chess960_to_spid(pos)
  start_str = pos.tr(CHESS_PIECES.join, "RNBQKRNBQK")
  #1 knights score
  s = start_str.delete("QB")
  n = [0,1,2,3,4].combination(2).to_a.index( [s.index("N"), s.rindex("N")] )
  #2 queen score
  q = start_str.delete("B").index("Q")
  #3 bishops
  bs = start_str.index("B"), start_str.rindex("B")
  d = bs.detect(&:even?).div(2)
  l = bs.detect(&:odd? ).div(2)

  96*n + 16*q + 4*d + l
end

%w<QNRBBNKR RNBQKBNR RQNBBKRN RNQBBKRN>.each_with_index do |array, i|
  pieces = array.tr("RNBQK", CHESS_PIECES[i%2])
  puts "#{pieces} (#{array}):  #{chess960_to_spid array}"
end
