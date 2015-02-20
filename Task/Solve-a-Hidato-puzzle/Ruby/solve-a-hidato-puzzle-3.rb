# Solve a Hidato Like Puzzle with Warnsdorff like logic applied
#
class HLPsolver
  attr_reader :board
  Cell = Struct.new(:value, :used, :adj)

  def initialize(board, pout=true)
    @board = []
    frame = ADJACENT.flatten.map(&:abs).max
    board.each_line do |line|
      @board << line.split.map{|n| Cell[Integer(n), false] rescue nil} + [nil]*frame
    end
    frame.times {@board << []}                  # frame (Sentinel value : nil)
    @board.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        if cell
          @sx, @sy = x, y  if cell.value==1     # start position
          cell.adj = ADJACENT.map{|dx,dy| [x+dx,y+dy]}.select{|xx,yy| @board[xx][yy]}
        end
      end
    end
    @xmax = @board.size - frame
    @ymax = @board.map(&:size).max - frame
    @end  = @board.flatten.compact.size
    @format = " %#{@end.to_s.size}s"
    puts to_s('Problem:')  if pout
  end

  def solve
    @zbl = Array.new(@end+1, false)
    @board.flatten.compact.each{|cell| @zbl[cell.value] = true}
    puts (try(@board[@sx][@sy], 1) ? to_s('Solution:') : "No solution")
  end

  def try(cell, seq_num)
    value = cell.value
    return false if value > 0 and value != seq_num
    return false if value == 0 and @zbl[seq_num]
    cell.used = true
    if seq_num == @end
      cell.value = seq_num
      return true
    end
    a = []
    cell.adj.each_with_index do |(x, y), n|
      cl = @board[x][y]
      a << [wdof(cl.adj)*10+n, x, y]  unless cl.used
    end
    a.sort.each do |key, x, y|
      if try(@board[x][y], seq_num+1)
        cell.value = seq_num
        return true
      end
    end
    cell.used = false
  end

  def wdof(adj)
    adj.count {|x,y| not @board[x][y].used}
  end

  def to_s(msg=nil)
    str = (0...@xmax).map do |x|
      (0...@ymax).map{|y| @format % ((c=@board[x][y]) ? c.value : c)}.join
    end
    (msg ? [msg] : []) + str + [""]
  end
end
