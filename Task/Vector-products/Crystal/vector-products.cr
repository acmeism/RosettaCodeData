class Vector
  property x, y, z

  def initialize(@x : Int64, @y : Int64, @z : Int64) end

  def dot_product(other : Vector)
    (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
  end

  def cross_product(other : Vector)
    Vector.new(self.y * other.z - self.z * other.y,
               self.z * other.x - self.x * other.z,
               self.x * other.y - self.y * other.x)
  end

  def scalar_triple_product(b : Vector, c : Vector)
    self.dot_product(b.cross_product(c))
  end

  def vector_triple_product(b : Vector, c : Vector)
    self.cross_product(b.cross_product(c))
  end

  def to_s
    "(#{self.x}, #{self.y}, #{self.z})\n"
  end
end

a = Vector.new(3, 4, 5)
b = Vector.new(4, 3, 5)
c = Vector.new(-5, -12, -13)

puts "a = #{a.to_s}"
puts "b = #{b.to_s}"
puts "c = #{c.to_s}"
puts "a dot b = #{a.dot_product b}"
puts "a cross b = #{a.cross_product(b).to_s}"
puts "a dot (b cross c) = #{a.scalar_triple_product b, c}"
puts "a cross (b cross c) = #{a.vector_triple_product(b, c).to_s}"
