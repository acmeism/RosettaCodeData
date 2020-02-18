import math
import fenv

type
  Rational = object
    numerator: int
    denominator: int

proc `$`(self: Rational): string =
  if self.denominator == 1:
    $self.numerator
  else:
    $self.numerator & "//" & $self.denominator

func rationalize(x: float, tol: float = epsilon(float)): Rational =
  var xx = x
  let flagNeg = xx < 0.0
  if flagNeg:
    xx = -xx
  if xx < minimumPositiveValue(float):
    return Rational(numerator: 0, denominator: 1)
  if abs(xx - round(xx)) < tol:
    return Rational(numerator: int(round(xx)), denominator: 1)
  var a = 0
  var b = 1
  var c = int(ceil(xx))
  var d = 1
  var aux1 = high(int) div 2
  while c < aux1 and d < aux1:
    var aux2 = (float(a) + float(c)) / (float(b) + float(d))
    if abs(xx - aux2) < tol:
      break
    if xx > aux2:
      inc a, c
      inc b, d
    else:
      inc c, a
      inc d, b
  var gcd = gcd(a + c, b + d)
  if flagNeg:
    Rational(numerator: -(a + c) div gcd, denominator: (b + d) div gcd)
  else:
    Rational(numerator: (a + c) div gcd, denominator: (b + d) div gcd)

echo rationalize(0.9054054054)
echo rationalize(0.9054054054, 0.0001)
echo rationalize(0.5185185185)
echo rationalize(0.5185185185, 0.0001)
echo rationalize(0.75)
echo rationalize(0.1428571428, 0.001)
echo rationalize(35.000)
echo rationalize(35.001)
echo rationalize(0.9)
echo rationalize(0.99)
echo rationalize(0.909)
echo rationalize(0.909, 0.001)
