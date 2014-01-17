# Solve a Hidato Puzzle
#
#  Nigel_Galloway
#  May 5th., 2012.
class Cell
  def self.[](*args) self.new(*args) end
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
