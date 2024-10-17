class Quaternion
  property a, b, c, d

  def initialize(@a : Int64, @b : Int64, @c : Int64, @d : Int64) end

  def norm; Math.sqrt(a**2 + b**2 + c**2 + d**2) end
  def conj; Quaternion.new(a, -b, -c, -d)        end
  def +(n)  Quaternion.new(a + n, b, c, d)       end
  def -(n)  Quaternion.new(a - n, b, c, d)       end
  def -()   Quaternion.new(-a, -b, -c, -d)       end
  def *(n)  Quaternion.new(a * n, b * n, c * n, d * n) end
  def ==(rhs : Quaternion) self.to_s == rhs.to_s end
  def +(rhs : Quaternion)
    Quaternion.new(a + rhs.a, b + rhs.b, c + rhs.c, d + rhs.d)
  end

  def -(rhs : Quaternion)
    Quaternion.new(a - rhs.a, b - rhs.b, c - rhs.c, d - rhs.d)
  end

  def *(rhs : Quaternion)
    Quaternion.new(
      a * rhs.a - b * rhs.b - c * rhs.c - d * rhs.d,
      a * rhs.b + b * rhs.a + c * rhs.d - d * rhs.c,
      a * rhs.c - b * rhs.d + c * rhs.a + d * rhs.b,
      a * rhs.d + b * rhs.c - c * rhs.b + d * rhs.a)
  end

  def to_s(io : IO) io << "(#{a} #{sgn(b)}i #{sgn(c)}j #{sgn(d)}k)\n" end
  private def sgn(n)  n.sign|1 == 1 ? "+ #{n}" : "- #{n.abs}"  end
end

struct Number
  def +(rhs : Quaternion)
    Quaternion.new(rhs.a + self, rhs.b, rhs.c, rhs.d)
  end

  def -(rhs : Quaternion)
    Quaternion.new(-rhs.a + self, -rhs.b, -rhs.c, -rhs.d)
  end

  def *(rhs : Quaternion)
    Quaternion.new(rhs.a * self, rhs.b * self, rhs.c * self, rhs.d * self)
  end
end

q0 = Quaternion.new(a: 1, b: 2, c: 3, d: 4)
q1 = Quaternion.new(2, 3, 4, 5)
q2 = Quaternion.new(3, 4, 5, 6)
r  = 7

puts "q0 = #{q0}"
puts "q1 = #{q1}"
puts "q2 = #{q2}"
puts "r  = #{r}"
puts
puts "normal of q0 = #{q0.norm}"
puts "-q0 = #{-q0}"
puts "conjugate of q0 = #{q0.conj}"
puts "q0 * (conjugate of q0) = #{q0 * q0.conj}"
puts "(conjugate of q0) * q0 = #{q0.conj * q0}"
puts
puts "r + q0 = #{r + q0}"
puts "q0 + r = #{q0 + r}"
puts
puts " q0 - r = #{q0 - r}"
puts "-q0 - r = #{-q0 - r}"
puts " r - q0 = #{r - q0}"
puts "-q0 + r = #{-q0 + r}"
puts
puts "r * q0 = #{r * q0}"
puts "q0 * r = #{q0 * r}"
puts
puts "q0 + q1 = #{q0 + q1}"
puts "q0 - q1 = #{q2 - q1}"
puts "q0 * q1 = #{q0 * q1}"
puts
puts " q0 + q1 * q2  = #{q0 + q1 * q2}"
puts "(q0 + q1) * q2 = #{(q0 + q1) * q2}"
puts
puts " q0 *  q1  * q2 = #{q0 * q1 * q2}"
puts "(q0 *  q1) * q2 = #{(q0 * q1) * q2}"
puts " q0 * (q1 * q2) = #{q0 * (q1 * q2)}"
puts
puts "q1 * q2 = #{q1 * q2}"
puts "q2 * q1 = #{q2 * q1}"
puts
puts "q1 * q2 != q2 * q1 => #{(q1 * q2) != (q2 * q1)}"
puts "q1 * q2 == q2 * q1 => #{(q1 * q2) == (q2 * q1)}"
