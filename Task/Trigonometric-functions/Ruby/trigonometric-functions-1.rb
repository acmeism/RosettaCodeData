radians = Math::PI / 4
degrees = 45.0

def deg2rad(d)
  d * Math::PI / 180
end

def rad2deg(r)
  r * 180 / Math::PI
end

#sine
puts "#{Math.sin(radians)} #{Math.sin(deg2rad(degrees))}"
#cosine
puts "#{Math.cos(radians)} #{Math.cos(deg2rad(degrees))}"
#tangent
puts "#{Math.tan(radians)} #{Math.tan(deg2rad(degrees))}"
#arcsine
arcsin = Math.asin(Math.sin(radians))
puts "#{arcsin} #{rad2deg(arcsin)}"
#arccosine
arccos = Math.acos(Math.cos(radians))
puts "#{arccos} #{rad2deg(arccos)}"
#arctangent
arctan = Math.atan(Math.tan(radians))
puts "#{arctan} #{rad2deg(arctan)}"
