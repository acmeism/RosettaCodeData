# Solve a Hidato Puzzle
#
class Hidato
  Cell = Struct.new(:value, :used, :adj)
  ADJUST = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  def initialize(board, pout=true)
    @board = []
    board.each_line do |line|
      @board << line.split.map{|n| Cell[Integer(n), false] rescue nil} + [nil]
    end
    @board << []                                # frame (Sentinel value : nil)
    @board.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        if cell
          @sx, @sy = x, y  if cell.value==1     # start position
          cell.adj = ADJUST.map{|dx,dy| [x+dx,y+dy]}.select{|xx,yy| @board[xx][yy]}
        end
      end
    end
    @xmax = @board.size - 1
    @ymax = @board.map(&:size).max - 1
    @end  = @board.flatten.compact.size
    puts to_s('Problem:')  if pout
  end

  def solve
    @zbl = Array.new(@end+1, false)
    @board.flatten.compact.each{|cell| @zbl[cell.value] = true}
    puts (try(@board[@sx][@sy], 1) ? to_s('Solution:') : "No solution")
  end

  def try(cell, seq_num)
    return true  if seq_num > @end
    return false if cell.used
    value = cell.value
    return false if value > 0 and value != seq_num
    return false if value == 0 and @zbl[seq_num]
    cell.used = true
    cell.adj.each do |x, y|
      if try(@board[x][y], seq_num+1)
        cell.value = seq_num
        return true
      end
    end
    cell.used = false
  end

  def to_s(msg=nil)
    str = (0...@xmax).map do |x|
      (0...@ymax).map{|y| "%3s" % ((c=@board[x][y]) ? c.value : c)}.join
    end
    (msg ? [msg] : []) + str + [""]
  end
end
