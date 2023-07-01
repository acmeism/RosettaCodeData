require 'bigdecimal'       # BigDecimal
require 'bigdecimal/math'  # BigMath

include BigMath  # Allow sin(x, prec) instead of BigMath.sin(x, prec).

# Tangent of _x_.
def tan(x, prec)
  sin(x, prec) / cos(x, prec)
end

# Arcsine of _y_, domain [-1, 1], range [-pi/2, pi/2].
def asin(y, prec)
  # Handle angles with no tangent.
  return -PI / 2 if y == -1
  return PI / 2 if y == 1

  # Tangent of angle is y / x, where x^2 + y^2 = 1.
  atan(y / sqrt(1 - y * y, prec), prec)
end

# Arccosine of _x_, domain [-1, 1], range [0, pi].
def acos(x, prec)
  # Handle angle with no tangent.
  return PI / 2 if x == 0

  # Tangent of angle is y / x, where x^2 + y^2 = 1.
  a = atan(sqrt(1 - x * x, prec) / x, prec)
  if a < 0
    a + PI(prec)
  else
    a
  end
end


prec = 52
pi = PI(prec)
degrees = pi / 180  # one degree in radians

b1 = BigDecimal.new "1"
b2 = BigDecimal.new "2"
b3 = BigDecimal.new "3"

f = proc { |big| big.round(50).to_s('F') }
print("Using radians:",
      "\n  sin(-pi / 6) = ", f[ sin(-pi / 6, prec) ],
      "\n  cos(3 * pi / 4) = ", f[ cos(3 * pi / 4, prec) ],
      "\n  tan(pi / 3) = ", f[ tan(pi / 3, prec) ],
      "\n  asin(-1 / 2) = ", f[ asin(-b1 / 2, prec) ],
      "\n  acos(-sqrt(2) / 2) = ", f[ acos(-sqrt(b2, prec) / 2, prec) ],
      "\n  atan(sqrt(3)) = ", f[ atan(sqrt(b3, prec), prec) ],
      "\n")
print("Using degrees:",
      "\n  sin(-30) = ", f[ sin(-30 * degrees, prec) ],
      "\n  cos(135) = ", f[ cos(135 * degrees, prec) ],
      "\n  tan(60) = ", f[ tan(60 * degrees, prec) ],
      "\n  asin(-1 / 2) = ",
      f[ asin(-b1 / 2, prec) / degrees ],
      "\n  acos(-sqrt(2) / 2) = ",
      f[ acos(-sqrt(b2, prec) / 2, prec) / degrees ],
      "\n  atan(sqrt(3)) = ",
      f[ atan(sqrt(b3, prec), prec) / degrees ],
      "\n")
