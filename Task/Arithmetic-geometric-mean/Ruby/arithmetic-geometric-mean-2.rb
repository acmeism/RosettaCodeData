require 'bigdecimal'

PRECISION = 100
EPSILON = 0.1 ** (PRECISION/2)
BigDecimal::limit(PRECISION)

def agm(a,g)
  while a - g > EPSILON
    a, g = (a+g)/2, (a*g).sqrt(PRECISION)
  end
  [a, g]
end

a = BigDecimal(1)
g = 1 / BigDecimal(2).sqrt(PRECISION)
puts agm(a, g)
