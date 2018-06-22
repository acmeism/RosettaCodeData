class Ball
  FLAG = {red: 1, white: 2, blue: 3}

  def initialize
    @color = FLAG.keys.sample
  end

  def color
    @color
  end

  def <=>(other)  # needed for sort, results in -1 for <, 0 for == and 1 for >.
    FLAG[self.color] <=> FLAG[other.color]
  end

  def inspect
    @color
  end
end

balls = []
balls = Array.new(8){Ball.new} while balls == balls.sort

puts "Random: #{balls}"
puts "Sorted: #{balls.sort}"
