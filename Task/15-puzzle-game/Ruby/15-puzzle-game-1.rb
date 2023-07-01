require 'io/console'

class Board
  SIZE = 4
  RANGE = 0...SIZE

  def initialize
    width = (SIZE*SIZE-1).to_s.size
    @frame = ("+" + "-"*(width+2)) * SIZE + "+"
    @form = "| %#{width}d " * SIZE + "|"
    @step = 0
    @orign = [*0...SIZE*SIZE].rotate.each_slice(SIZE).to_a.freeze
    @board = @orign.map{|row | row.dup}
    randomize
    draw
    message
    play
  end

  private

  def randomize
    @board[0][0], @board[SIZE-1][SIZE-1] = 0, 1
    @board[SIZE-1][0], @board[0][SIZE-1] = @board[0][SIZE-1], @board[SIZE-1][0]
    x, y, dx, dy = 0, 0, 1, 0
    50.times do
      nx,ny = [[x+dx,y+dy], [x+dy,y-dx], [x-dy,y+dx]]
                .select{|nx,ny| RANGE.include?(nx) and RANGE.include?(ny)}
                .sample
      @board[nx][ny], @board[x][y] = 0, @board[nx][ny]
      x, y, dx, dy = nx, ny, nx-x, ny-y
    end
    @x, @y = x, y
  end

  def draw
    puts "\e[H\e[2J"
    @board.each do |row|
      puts @frame
      puts (@form % row).sub(" 0 ", "   ")
    end
    puts @frame
    puts "Step: #{@step}"
  end

  DIR = {up: [-1,0], down: [1,0], left: [0,-1], right: [0,1]}
  def move(direction)
    dx, dy = DIR[direction]
    nx, ny = @x + dx, @y + dy
    if RANGE.include?(nx) and RANGE.include?(ny)
      @board[nx][ny], @board[@x][@y] = 0, @board[nx][ny]
      @x, @y = nx, ny
      @step += 1
      draw
    end
  end

  def play
    until @board == @orign
      case  key_in
      when "\e[A", "w" then move(:up)
      when "\e[B", "s" then move(:down)
      when "\e[C", "d" then move(:right)
      when "\e[D", "a" then move(:left)

      when "q","\u0003","\u0004"  then exit
      when "h"  then message
      end
    end

    puts "Congratulations, you have won!"
  end

  def key_in
    input = STDIN.getch
    if input == "\e"
      2.times {input << STDIN.getch}
    end
    input
  end

  def message
    puts <<~EOM
      Use the arrow-keys or WASD on your keyboard to push board in the given direction.
      PRESS q TO QUIT (or Ctrl-C or Ctrl-D)
    EOM
  end
end

Board.new
