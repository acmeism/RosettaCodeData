record Vector, x : Float64, y : Float64 do
  def self.polar (value, angle)
    new value*Math.cos(angle), value*Math.sin(angle)
  end

  def + (other)
    Vector.new(x + other.x, y + other.y)
  end

  def - ()
    Vector.new(-x, -y)
  end

  def - (other)
    Vector.new(x - other.x, y - other.y)
  end

  def * (scalar)
    Vector.new(x * scalar, y * scalar)
  end

  def / (scalar)
    Vector.new(x / scalar, y / scalar)
  end

  def to_s (io)
    xs, ys = [x, y].map &.format(delimiter: nil, decimal_places: 6, only_significant: true)
    io << "Vector{" << xs << ", " << ys << "}"
  end
end

u = Vector.new 1, 2
v = Vector.polar 2, Math::PI/3

puts "u = #{u}\nv = #{v}"
puts "u + v = #{u + v}\nu - v = #{u - v}\nu * 2 = #{u * 2}\nv / 2 = #{v / 2}"
