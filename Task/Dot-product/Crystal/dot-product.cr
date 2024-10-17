class Vector
  property x, y, z

  def initialize(@x : Int64, @y : Int64, @z : Int64) end

  def dot_product(other : Vector)
    (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
  end
end

puts Vector.new(1, 3, -5).dot_product Vector.new(4, -2, -1) # => 3

class Array
  def dot_product(other)
    raise "not the same size!" if self.size != other.size
    self.zip(other).sum { |(a, b)| a * b }
  end
end

p [8, 13, -5].dot_product [4, -7, -11]   # => -4
