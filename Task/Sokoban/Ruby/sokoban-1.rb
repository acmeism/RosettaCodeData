require 'set'

class Sokoban
  def initialize(level)
    board = level.each_line.map(&:rstrip)
    @nrows = board.map(&:size).max
    board.map!{|line| line.ljust(@nrows)}
    board.each_with_index do |row, r|
      row.each_char.with_index do |ch, c|
        @px, @py = c, r  if ch == '@' or ch == '+'
      end
    end
    @goal = board.join.tr(' .@#$+*', ' .   ..')
                 .each_char.with_index.select{|ch, c| ch == '.'}
                 .map(&:last)
    @board = board.join.tr(' .@#$+*', '  @#$ $')
  end

  def pos(x, y)
    y * @nrows + x
  end

  def push(x, y, dx, dy, board)         # modify board
    return  if board[pos(x+2*dx, y+2*dy)] != ' '
    board[pos(x     , y     )] = ' '
    board[pos(x + dx, y + dy)] = '@'
    board[pos(x+2*dx, y+2*dy)] = '$'
  end

  def solved?(board)
    @goal.all?{|i| board[i] == '$'}
  end

  DIRS = [[0, -1, 'u', 'U'], [ 1, 0, 'r', 'R'], [0,  1, 'd', 'D'], [-1, 0, 'l', 'L']]
  def solve
    queue = [[@board, "", @px, @py]]
    visited = Set[@board]

    until queue.empty?
      current, csol, x, y = queue.shift

      for dx, dy, cmove, cpush in DIRS
        work = current.dup
        case work[pos(x+dx, y+dy)]      # next character
        when '$'
          next  unless push(x, y, dx, dy, work)
          next  unless visited.add?(work)
          return csol+cpush  if solved?(work)
          queue << [work, csol+cpush, x+dx, y+dy]
        when ' '
          work[pos(x, y)]       = ' '
          work[pos(x+dx, y+dy)] = '@'
          queue << [work, csol+cmove, x+dx, y+dy]  if visited.add?(work)
        end
      end
    end
    "No solution"
  end
end
