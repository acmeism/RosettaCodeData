# Calculate Pi using the Arithmetic Geometric Mean of 1 and 1/sqrt(2)
#
#
#  Nigel_Galloway
#  March 8th., 2012.
#
require 'flt'
Flt::BinNum.Context.precision = 8192
a = n = 1
g = 1 / Flt::BinNum(2).sqrt
z = 0.25
(0..17).each{
  x = [(a + g) * 0.5, (a * g).sqrt]
  var = x[0] - a
  z -= var * var * n
  n += n
  a = x[0]
  g = x[1]
}
puts a * a / z
