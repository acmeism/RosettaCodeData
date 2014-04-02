# Solve a Hidato Puzzle
#
#  Nigel_Galloway
#  May 5th., 2012.
class Cell
  def initialize(row=0, col=0, value=nil)
    @adj = [[row-1,col-1],[row,col-1],[row+1,col-1],[row-1,col],[row+1,col],[row-1,col+1],[row,col+1],[row+1,col+1]]
    @t = false
    $zbl[value] = true unless value.nil?
    @value = value
  end
  def try(value=1)
    return false if @value.nil?
    return true  if value > $end
    return false if @t
    return false if @value > 0 and @value != value
    return false if @value == 0 and $zbl[value]
    @t = true
    @adj.each do |x,y|
      if $board[x][y].try(value+1)
        @value = value
        return true
      end
    end
    @t = false
  end
  attr_reader :value
end

class Hidato
  def initialize(board, pout=true)
    $end = 0
    $zbl = []
    $board = []
    board.each_line.with_index do |line, x|
      $board << line.split.each_with_index.map do |n,y|
        begin
          n = Integer(n)
          @sx, @sy = x, y  if n == 1   # start position
          $end += 1
          Cell.new(x, y, n)
        rescue
          Cell.new                     # frame (Sentinel value)
        end
      end
    end
    @xmax = $board.size - 2
    @ymax = $board[1].size - 2
    printout('Problem:') if pout
  end
  def solve
    if $board[@sx][@sy].try(1)
      printout('Solution:')
    else
      puts "no solution"
    end
  end
  def printout(msg=nil)
    puts msg if msg
    (1..@xmax).each do |x|
      puts (1..@ymax).map{|y| "%3s" % $board[x][y].value}.join
    end
    puts
  end
end
