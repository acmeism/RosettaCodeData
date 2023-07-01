Point = Struct.new(:x, :y)

class Line
  attr_reader :a, :b

  def initialize(point1, point2)
    @a = (point1.y - point2.y).fdiv(point1.x - point2.x)
    @b = point1.y - @a*point1.x
  end

  def intersect(other)
    return nil if @a == other.a
    x = (other.b - @b).fdiv(@a - other.a)
    y = @a*x + @b
    Point.new(x,y)
  end

  def to_s
    "y = #{@a}x #{@b.positive? ? '+' : '-'} #{@b.abs}"
  end

end

l1 = Line.new(Point.new(4, 0), Point.new(6, 10))
l2 = Line.new(Point.new(0, 3), Point.new(10, 7))

puts "Line #{l1} intersects line #{l2} at #{l1.intersect(l2)}."
