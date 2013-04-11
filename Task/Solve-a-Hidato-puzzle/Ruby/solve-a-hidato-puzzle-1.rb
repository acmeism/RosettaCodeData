# Solve a Hidato Puzzle
#
#  Nigel_Galloway
#  May 5th., 2012.
class Cell
  def initialize(row=0, col=0, value=nil)
    @adj = [[row-1,col-1],[row,col-1],[row+1,col-1],[row-1,col],[row+1,col],[row-1,col+1],[row,col+1],[row+1,col+1]]
    @t = false
    $zbl[value] = false unless value == nil
    @value = value
  end
  def try(value)
    return false if @value == nil
    return true if value > E
    return false if @t
    return false if @value > 0 and @value != value
    return false if @value == 0 and not $zbl[value]
    @t = true
    @adj.each{|x|
      if (Board[x[0]][x[1]].try(value+1)) then
        @value = value
        return true
      end
    }
    @t = false
    return false
  end
  def value
    return @value
  end
end
