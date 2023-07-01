class Point
  attr_accessor :x,:y
  def initialize(x=0, y=0)
    self.x = x
    self.y = y
  end
  def to_s
    "Point at #{x},#{y}"
  end
end

# When defining Circle class as the sub-class of the Point class:
class Circle < Point
  attr_accessor :r
  def initialize(x=0, y=0, r=0)
    self.x = x
    self.y = y
    self.r = r
  end
  def to_s
    "Circle at #{x},#{y} with radius #{r}"
  end
end
