class Ant
  Directions = [:north, :east, :south, :west]

  def initialize(plane, pos_x, pos_y)
    @plane = plane
    @position = Position.new(plane, pos_x, pos_y)
    @direction = :south
  end
  attr_reader :plane, :direction, :position

  def run
    moves = 0
    loop do
      begin
        if $DEBUG and moves % 100 == 0
          system "clear"
          puts "%5d %s" % [moves, position]
          puts plane
        end
        moves += 1
        move
      rescue OutOfBoundsException
        break
      end
    end
    moves
  end

  def move
    plane.at(position).toggle_colour
    position.advance(direction)
    if plane.at(position).white?
      turn(:right)
    else
      turn(:left)
    end
  end

  def turn(left_or_right)
    idx = Directions.index(direction)
    case left_or_right
    when :left  then @direction = Directions[(idx - 1) % Directions.length]
    when :right then @direction = Directions[(idx + 1) % Directions.length]
    end
  end
end

class Plane
  def initialize(x, y)
    @x = x
    @y = y
    @cells = Array.new(y) {Array.new(x) {Cell.new}}
  end
  attr_reader :x, :y

  def at(position)
    @cells[position.y][position.x]
  end

  def to_s
    @cells.collect {|row|
      row.collect {|cell| cell.white? ? "." : "#"}.join + "\n"
    }.join
  end
end

class Cell
  def initialize
    @colour = :white
  end
  attr_reader :colour

  def white?
    colour == :white
  end

  def toggle_colour
    @colour = (white? ? :black : :white)
  end
end

class Position
  def initialize(plane, x, y)
    @plane = plane
    @x = x
    @y = y
    check_bounds
  end
  attr_accessor :x, :y

  def advance(direction)
    case direction
    when :north then @y -= 1
    when :east  then @x += 1
    when :south then @y += 1
    when :west  then @x -= 1
    end
    check_bounds
  end

  def check_bounds
    unless (0 <= @x and @x < @plane.x) and (0 <= @y and @y < @plane.y)
      raise OutOfBoundsException, to_s
    end
  end

  def to_s
    "(%d, %d)" % [x, y]
  end
end

class OutOfBoundsException < StandardError; end

#
# the simulation
#
ant = Ant.new(Plane.new(100, 100), 50, 50)
moves = ant.run
puts "out of bounds after #{moves} moves: #{ant.position}"
puts ant.plane
