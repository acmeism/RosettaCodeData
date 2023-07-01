class Board
  Cell = Struct.new(:value, :adj) do
    def self.end=(end_val)
      @@end = end_val
    end

    def try(seq_num)
      self.value = seq_num
      return true  if seq_num==@@end
      a = []
      adj.each_with_index do |cell, n|
        a << [wdof(cell.adj)*10+n, cell]  if cell.value.zero?
      end
      a.sort.each {|_, cell| return true  if cell.try(seq_num+1)}
      self.value = 0
      false
    end

    def wdof(adj)
      adj.count {|cell| cell.value.zero?}
    end
  end

  def initialize(rows, cols)
    @rows, @cols = rows, cols
    unless defined? ADJACENT                      # default move (Knight)
      eval("ADJACENT = [[-1,-2],[-2,-1],[-2,1],[-1,2],[1,2],[2,1],[2,-1],[1,-2]]")
    end
    frame = ADJACENT.flatten.map(&:abs).max
    @board = Array.new(rows+frame) do |i|
      Array.new(cols+frame) do |j|
        (i<rows and j<cols) ? Cell.new(0) : nil   # frame (Sentinel value : nil)
      end
    end
    rows.times do |i|
      cols.times do |j|
        @board[i][j].adj = ADJACENT.map{|di,dj| @board[i+di][j+dj]}.compact
      end
    end
    Cell.end = rows * cols
    @format = " %#{(rows * cols).to_s.size}d"
  end

  def solve(sx, sy)
    if (@rows*@cols).odd? and (sx+sy).odd?
      puts "No solution"
    else
      puts (@board[sx][sy].try(1) ? to_s : "No solution")
    end
  end

  def to_s
    (0...@rows).map do |x|
      (0...@cols).map{|y| @format % @board[x][y].value}.join
    end
  end
end

def knight_tour(rows=8, cols=rows, sx=rand(rows), sy=rand(cols))
  puts "\nBoard (%d x %d), Start:[%d, %d]" % [rows, cols, sx, sy]
  Board.new(rows, cols).solve(sx, sy)
end

knight_tour(8,8,3,1)

knight_tour(5,5,2,2)

knight_tour(4,9,0,0)

knight_tour(5,5,0,1)

knight_tour(12,12,1,1)
