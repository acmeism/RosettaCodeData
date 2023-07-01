class Game
  def initialize(name, size, generations, initial_life=nil)
    @size = size
    @board = GameBoard.new size, initial_life
    @board.display name, 0

    reason = generations.times do |gen|
      new_board = evolve
      new_board.display name, gen+1
      break :all_dead if new_board.barren?
      break :static   if @board == new_board
      @board = new_board
    end

    case reason
    when :all_dead  then puts "No more life."
    when :static    then puts "No movement."
    else                 puts "Specified lifetime ended."
    end
    puts
  end

  def evolve
    life = @board.each_index.select {|i,j| cell_fate(i,j)}
    GameBoard.new @size, life
  end

  def cell_fate(i, j)
    left_right = [0, i-1].max .. [i+1, @size-1].min
    top_bottom = [0, j-1].max .. [j+1, @size-1].min
    sum = 0
    for x in left_right
      for y in top_bottom
        sum += @board[x,y].value if x != i or y != j
      end
    end
    sum == 3 or (sum == 2 and @board[i,j].alive?)
  end
end

class GameBoard
  include Enumerable

  def initialize(size, initial_life=nil)
    @size = size
    @board = Array.new(size) {Array.new(size) {Cell.new false}}
    seed_board initial_life
  end

  def seed_board(life)
    if life.nil?
      # randomly seed board
      each_index.to_a.sample(10).each {|x,y| @board[y][x].live}
    else
      life.each {|x,y| @board[y][x].live}
    end
  end

  def each
    @size.times {|x| @size.times {|y| yield @board[y][x] }}
  end

  def each_index
    return to_enum(__method__) unless block_given?
    @size.times {|x| @size.times {|y| yield x,y }}
  end

  def [](x, y)
    @board[y][x]
  end

  def ==(board)
    self.life == board.life
  end

  def barren?
    none? {|cell| cell.alive?}
  end

  def life
    each_index.select {|x,y| @board[y][x].alive?}
  end

  def display(name, generation)
    puts "#{name}: generation #{generation}"
    puts @board.map {|row| row.map {|cell| cell.alive? ? '#' : '.'}.join(' ')}
  end

  def apocalypse
    # utility function to entirely clear the game board
    each {|cell| cell.die}
  end
end

class Cell
  def initialize(alive) @alive = alive  end
  def alive?;           @alive          end
  def value;            @alive ? 1 : 0  end
  def live;             @alive = true   end
  def die;              @alive = false  end
end

Game.new "blinker", 3, 2, [[1,0],[1,1],[1,2]]
Game.new "glider", 4, 4, [[1,0],[2,1],[0,2],[1,2],[2,2]]
Game.new "random", 5, 10
