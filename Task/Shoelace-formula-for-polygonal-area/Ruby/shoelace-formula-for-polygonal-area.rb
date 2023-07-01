Point = Struct.new(:x,:y) do

  def shoelace(other)
    x * other.y - y * other.x
  end

end

class Polygon

  def initialize(*coords)
    @points = coords.map{|c| Point.new(*c) }
  end

  def area
    points = @points + [@points.first]
    points.each_cons(2).sum{|p1,p2| p1.shoelace(p2) }.abs.fdiv(2)
  end

end

puts Polygon.new([3,4], [5,11], [12,8], [9,5], [5,6]).area  # => 30.0
