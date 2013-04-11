require 'matrix' # For Vector#norm

class Quaternion
  def initialize(*parts)
    raise "Invalid number of quaternion parts" unless parts.length == 4
    @parts, @vector = parts, Vector[*parts]
  end

  def to_a;          @parts;                                       end
  def to_s;          "Quaternion#{to_a.to_s}"                      end
  def complex_parts; [Complex(*to_a[0..1]), Complex(*to_a[2..3])]; end
  def zip(other);    to_a.zip(other.to_a);                         end

  def real;          @parts.first;                                 end
  def imag;          @parts[1..3];                                 end
  def conj;          Quaternion.new(real, *imag.map(&:-@));        end
  def norm;          @vector.norm;                                 end # Or: Math.sqrt(to_a.reduce { |sum, e| sum + e**2 }) # In Rails: Math.sqrt(to_a.sum { e**2 })

  def ==(other);     to_a == other.to_a                            end
  def -@;            Quaternion.new(*to_a.map(&:-@));              end
  def -(other);      self + -other;                                end

  def +(other)
    case other
    when Numeric
      Quaternion.new(real + other, *imag)
    when Quaternion
      Quaternion.new(*zip(other).map { |x,y| x + y }) # In Rails: zip(other).map(&:sum) # Or: (vector + other.vector).to_a
    end
  end

  def *(other)
    case other
    when Numeric
      Quaternion.new(*to_a.map { |x| x * other }) # Or: (vector * other).to_a
    when Quaternion
      # Multiplication of quaternions in C x C space. See "Cayley-Dickson construction".
      a, b, c, d = *complex_parts, *other.complex_parts
      x, y = a*c - d.conj*b, a*d + b*c.conj
      Quaternion.new(x.real, x.imag, y.real, y.imag)
    end
  end

  # Coerce is called by Ruby to return a compatible type/receiver when the called method/operation does not accept a Quaternion
  def coerce(other)
    case other
    when Numeric then [Scalar.new(other), self]
    else raise TypeError, "#{other.class} can't be coerced into #{self.class}"
    end
  end

  class Scalar
    def initialize(val); @val = val;                            end
    def +(other);        other + @val;                          end
    def *(other);        other * @val;                          end
    def -(other);        Quaternion.new(@val, 0, 0, 0) - other; end
  end
end
