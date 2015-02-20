require 'set'

class Sokoban
  def initialize(level)
    board = level.each_line.map(&:chomp)
    @nrows = board.map(&:size).max
    board = board.map{|line| line.ljust(@nrows)}
    board.each_with_index do |row, r|
      row.each_char.with_index do |ch, c|
        @px, @py = c, r  if ch == '@' or ch == '+'
      end
    end
    goal = board.join.tr(' .@#$+*', ' .   ..')
    @goal = goal.each_char.with_index.select{|ch, c| ch == '.'}.map(&:last)
    @data = board.join.tr(' .@#$+*', '  @#$ $')
  end

  def pos(x, y)
    y * @nrows + x
  end

  def push(x, y, dx, dy, data)
    return data  if data[pos(x+2*dx, y+2*dy)] != ' '
    data[pos(x     , y     )] = ' '
    data[pos(x + dx, y + dy)] = '@'
    data[pos(x+2*dx, y+2*dy)] = '$'
    data
  end

  def solved?(data)
    @goal.all?{|i| data[i] == '$'}
  end

  DIRS = [[0, -1, 'u', 'U'], [ 1, 0, 'r', 'R'], [0,  1, 'd', 'D'], [-1, 0, 'l', 'L']]
  def solve
    open = [[@data, "", @px, @py]]
    visited = Set[@data]

    until open.empty?
      cur, csol, x, y = open.shift

      for dx, dy, cmove, cpush in DIRS
        temp = cur.dup
        ps = pos(x+dx, y+dy)
        if temp[ps] == '$'
          temp = push(x, y, dx, dy, temp)
          next  if visited.include?(temp)
          visited.add(temp)
          return csol + cpush  if solved?(temp)
          open << [temp, csol + cpush, x+dx, y+dy]
        else
          next  if @data[ps] == '#' or temp[ps] != ' '
          temp[pos(x, y)] = ' '
          temp[ps]        = '@'
          next  if visited.include?(temp)
          visited.add(temp)
          open << [temp, csol + cmove, x+dx, y+dy]
        end
      end
    end
    "No solution"
  end
end
