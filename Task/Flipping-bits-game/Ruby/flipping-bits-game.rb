class FlipBoard
  def initialize(size)
    raise ArgumentError.new("Invalid board size: #{size}") if size < 2

    @size = size
    @board = Array.new(size**2, 0)

    randomize_board
    loop do
      @target = generate_target
      break unless solved?
    end

    # these are used for validating user input
    @columns = [*'a'...('a'.ord+@size).chr]
    @rows = (1..@size).map(&:to_s)
  end

  ############################################################

  def play
    moves = 0
    puts "your target:", target

    until solved?
      puts "", "move #{moves}:", self
      print "Row/column to flip: "
      ans = $stdin.gets.strip

      if @columns.include? ans
        flip_column @columns.index(ans)
        moves += 1
      elsif @rows.include? ans
        flip_row @rows.index(ans)
        moves += 1
      else
        puts "invalid input: " + ans
      end
    end

    puts "", "you solved the game in #{moves} moves", self
  end

  # the target formation as a string
  def target
    format_array @target
  end

  # the current formation as a string
  def to_s
    format_array @board
  end

  ############################################################
  private

  def solved?
    @board == @target
  end

  # flip a random number of bits on the board
  def randomize_board
    (@size + rand(@size)).times do
      flip_bit rand(@size), rand(@size)
    end
  end

  # generate a random number of flip_row/flip_column calls
  def generate_target
    orig_board = @board.clone
    (@size + rand(@size)).times do
      rand(2).zero? ? flip_row( rand(@size) ) : flip_column( rand(@size) )
    end
    target, @board = @board, orig_board
    target
  end

  def flip_row(row)
    @size.times {|col| flip_bit(row, col)}
  end

  def flip_column(col)
    @size.times {|row| flip_bit(row, col)}
  end

  def flip_bit(row, col)
    @board[@size * row + col] ^= 1
  end

  def format_array(ary)
    str = "   " + @columns.join(" ") + "\n"
    @size.times do |row|
      str << "%2s " % @rows[row] + ary[@size*row, @size].join(" ") + "\n"
    end
    str
  end
end

######################################################################
begin
  FlipBoard.new(ARGV.shift.to_i).play
rescue => e
  puts e.message
end
