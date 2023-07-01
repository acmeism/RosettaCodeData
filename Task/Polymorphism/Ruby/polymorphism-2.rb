# create a point
puts Point.new          # => Point at 0,0
p = Point.new(1, 2)
puts p                  # => Point at 1,2
puts p.x                # => 1
p.y += 1
puts p                  # => Point at 1,3

# create a circle
c = Circle.new(4,5,6)
# copy it
d = c.dup
d.r = 7.5
puts c                  # => Circle at 4,5 with radius 6
puts d                  # => Circle at 4,5 with radius 7.5
