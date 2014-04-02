# Solve a Hidato Puzzle with Warnsdorff like logic applied
#
#  Nigel_Galloway
#  May 6th., 2012.
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
    h = Hash.new
    @adj.each_with_index do |(x,y), n|
      cell = $board[x][y]
      h[cell.wdof*10+n] = cell  if cell.value
    end
    h.sort.each do |key, cell|
      if (cell.try(value+1))
        @value = value
        return true
      end
    end
    @t = false
  end
  def wdon
    (@value.nil? or @value > 0 or @t) ? 0 : 1
  end
  def wdof
    @adj.inject(0){|res, (x,y)| res += $board[x][y].wdon}
  end
  attr_reader :value
end
