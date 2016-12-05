import math

proc `^`[T](base, exp: T): T =
  var (base, exp) = (base, exp)
  result = 1

  while exp != 0:
    if (exp and 1) != 0:
      result *= base
    exp = exp shr 1
    base *= base

proc gcd[T](u, v: T): T =
  if v != 0:
    gcd(v, u mod v)
  else:
    u.abs

proc lcm[T](a, b: T): T =
  a div gcd(a, b) * b

type Rational* = tuple[num, den: int64]

proc fromInt*(x: SomeInteger): Rational =
  result.num = x
  result.den = 1

proc frac*(x: var Rational) =
  let common = gcd(x.num, x.den)
  x.num = x.num div common
  x.den = x.den div common

proc `+` *(x, y: Rational): Rational =
  let common = lcm(x.den, y.den)
  result.num = common div x.den * x.num + common div y.den * y.num
  result.den = common
  result.frac

proc `+=` *(x: var Rational, y: Rational) =
  let common = lcm(x.den, y.den)
  x.num = common div x.den * x.num + common div y.den * y.num
  x.den = common
  x.frac

proc `-` *(x: Rational): Rational =
  result.num = -x.num
  result.den = x.den

proc `-` *(x, y: Rational): Rational =
  x + -y

proc `-=` *(x: var Rational, y: Rational) =
  x += -y

proc `*` *(x, y: Rational): Rational =
  result.num = x.num * y.num
  result.den = x.den * y.den
  result.frac

proc `*=` *(x: var Rational, y: Rational) =
  x.num *= y.num
  x.den *= y.den
  x.frac

proc reciprocal*(x: Rational): Rational =
  result.num = x.den
  result.den = x.num

proc `div`*(x, y: Rational): Rational =
  x * y.reciprocal

proc toFloat*(x: Rational): float =
  x.num.float / x.den.float

proc toInt*(x: Rational): int64 =
  x.num div x.den

proc cmp*(x, y: Rational): int =
  cmp x.toFloat, y.toFloat

proc `<` *(x, y: Rational): bool =
  x.toFloat < y.toFloat

proc `<=` *(x, y: Rational): bool =
  x.toFloat <= y.toFloat

proc abs*(x: Rational): Rational =
  result.num = abs x.num
  result.den = abs x.den

for candidate in 2'i64 .. <((2'i64)^19):
  var sum: Rational = (1'i64, candidate)
  for factor in 2'i64 .. pow(candidate.float, 0.5).int64:
    if candidate mod factor == 0:
      sum += (1'i64, factor) + (1'i64, candidate div factor)
  if sum.den == 1:
    echo "Sum of recipr. factors of ",candidate," = ",sum.num," exactly ",
      if sum.num == 1: "perfect!" else: ""
