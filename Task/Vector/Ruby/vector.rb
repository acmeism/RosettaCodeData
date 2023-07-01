class Vector
  def self.polar(r, angle=0)
    new(r*Math.cos(angle), r*Math.sin(angle))
  end

  attr_reader :x, :y

  def initialize(x, y)
    raise TypeError unless x.is_a?(Numeric) and y.is_a?(Numeric)
    @x, @y = x, y
  end

  def +(other)
    raise TypeError if self.class != other.class
    self.class.new(@x + other.x, @y + other.y)
  end

  def -@;       self.class.new(-@x, -@y)        end
  def -(other)  self + (-other)                 end

  def *(scalar)
    raise TypeError unless scalar.is_a?(Numeric)
    self.class.new(@x * scalar, @y * scalar)
  end

  def /(scalar)
    raise TypeError unless scalar.is_a?(Numeric) and scalar.nonzero?
    self.class.new(@x / scalar, @y / scalar)
  end

  def r;        @r     ||= Math.hypot(@x, @y)   end
  def angle;    @angle ||= Math.atan2(@y, @x)   end
  def polar;    [r, angle]                      end
  def rect;     [@x, @y]                        end
  def to_s;     "#{self.class}#{[@x, @y]}"      end
  alias inspect to_s
end

p v = Vector.new(1,1)                   #=> Vector[1, 1]
p w = Vector.new(3,4)                   #=> Vector[3, 4]
p v + w                                 #=> Vector[4, 5]
p v - w                                 #=> Vector[-2, -3]
p -v                                    #=> Vector[-1, -1]
p w * 5                                 #=> Vector[15, 20]
p w / 2.0                               #=> Vector[1.5, 2.0]
p w.x                                   #=> 3
p w.y                                   #=> 4
p v.polar                               #=> [1.4142135623730951, 0.7853981633974483]
p w.polar                               #=> [5.0, 0.9272952180016122]
p z = Vector.polar(1, Math::PI/2)       #=> Vector[6.123031769111886e-17, 1.0]
p z.rect                                #=> [6.123031769111886e-17, 1.0]
p z.polar                               #=> [1.0, 1.5707963267948966]
p z = Vector.polar(-2, Math::PI/4)      #=> Vector[-1.4142135623730951, -1.414213562373095]
p z.polar                               #=> [2.0, -2.356194490192345]
