# Solve a Hidato Puzzle with Warnsdorff like logic applied
#
#  Nigel_Galloway
#  May 6th., 2012.
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
    h = Hash.new
    n = 0
    @adj.each{|x|
      h[Board[x[0]][x[1]].wdof*10+n] = Board[x[0]][x[1]]
      n += 1
    }
    h.sort.each{|key,cell|
      if (cell.try(value+1)) then
        @value = value
        return true
      end
    }
    @t = false
    return false
  end
  def wdon
    return 0 if @value == nil
    return 0 if @value > 0
    return 0 if @t
    return 1
  end
  def wdof
    res = 0
    @adj.each{|x| res += Board[x[0]][x[1]].wdon}
    return res
  end
  def value
    return @value
  end
end
