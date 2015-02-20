class Sokoban
  def initialize(level)
    board = level.lines.map(&:rstrip)
    leng  = board.map(&:length).max
    board = board.map{|line| line.ljust(leng)}.join
    @goal = []
    board.each_char.with_index do |c, i|
      @player = i  if c == '@' or c == '+'
      @goal << i   if c == '.' or c == '+' or c == '*'
    end
    @board = board.tr(' .@#$+*', '  @#$ $')
    @lurd = [[-1, 'l', 'L'], [-leng, 'u', 'U'], [1, 'r', 'R'], [leng, 'd', 'D']]
    @dirs = @lurd.map(&:first)
    set_dead_zone(board.tr('^#', ' '))
  end

  def set_dead_zone(wall)
    corner = search_corner(wall)
    @dead = corner.dup
    begin
      size = @dead.size
      corner.each do |pos|
        @dirs.each do |dir|
          next  if wall[pos + dir] == '#'
          @dead.concat(check_side(wall, pos+dir, dir))
        end
      end
    end until size == @dead.size
  end

  def search_corner(wall)
    wall.size.times.with_object([]) do |i, corner|
      next  if wall[i] == '#' or @goal.include?(i)
      case count_wall(wall, i)
      when 2
        corner << i  if wall[i-1] != wall[i+1]
      when 3
        corner << i
      end
    end
  end

  def check_side(wall, pos, dir)
    wk = []
    until wall[pos] == '#' or count_wall(wall, pos) == 0 or @goal.include?(pos)
      return wk if @dead.include?(pos)
      wk << pos
      pos += dir
    end
    []
  end

  def count_wall(wall, pos)
    @dirs.count{|dir| wall[pos + dir] == '#'}
  end

  def push_box(pos, dir, board)
    return board  if board[pos + 2*dir] != ' '
    board[pos        ] = ' '
    board[pos +   dir] = '@'
    board[pos + 2*dir] = '$'
    board
  end

  def solved?(board)
    @goal.all?{|i| board[i] == '$'}
  end

  def solve
    queue = [[@board, "", @player]]
    # When the key doesn't exist in Hash, it subscribes a key but it returns false.
    visited = Hash.new{|h,k| h[k]=true; false}
    visited[@board]                     # first subscription

    until queue.empty?
      board, route, pos = queue.shift
      @lurd.each do |dir, move, push|
        work = board.dup
        case work[pos+dir]
        when '$'    # push
          work = push_box(pos, dir, work)
          next  if visited[work]
          return route+push  if solved?(work)
          queue << [work, route+push, pos+dir]  unless @dead.include?(pos+2*dir)
        when ' '    # move
          work[pos    ] = ' '
          work[pos+dir] = '@'
          next  if visited[work]
          queue << [work, route+move, pos+dir]
        end
      end
    end
    "No solution"
  end
end
