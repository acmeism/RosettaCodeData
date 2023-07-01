import math, strutils, strformat
import decimal
import bignum

####################################################################################################
# Utilities.

proc format[T: DecimalType|Rat](val: T; intLen, fractLen: Positive): string =
  ## Format a decimal or a rational with "intLen" integer digits and "fractLen"
  ## fractional digits.
  let s = when T is DecimalType: ($val).split('.')
          else: ($val.toFloat).split('.')

  result = s[0].align(intLen) & '.'
  if s[1].len < fractLen:
    result.add s[1].alignLeft(fractLen, '0')
  else:
    result.add s[1][0..<fractLen]


proc `^`(a: Rat; b: Natural): Rat =
  ## Missing exponentiation operator for rationals.
  ## Adaptation of operator for floats.
  case b
  of 0: result = newRat(1)
  of 1: result = a
  of 2: result = a * a
  of 3: result = a * a * a
  else:
    var (a, b) = (a.clone, b)
    result = newRat(1)
    while true:
      if (b and 1) != 0:
        result *= a
      b = b shr 1
      if b == 0: break
      a *= a


####################################################################################################
# Task 1.

proc v[T: float|DecimalType|Rat](n: Positive): seq[T] =
  ## Return the "n" first values for sequence "Vn".
  var (v1, v2) = when T is float: (2.0, -4.0)
                 elif T is Rat: (newRat(2), newRat(-4))
                 else: (newDecimal(2), newDecimal(-4))

  result.add default(T)   # Dummy value to start at index one.
  result.add v1
  result.add v2
  for _ in 3..n:
    # Need to change evaluation order to avoid a bug with rationals.
    result.add 3000 / (result[^1] * result[^2]) - 1130 / result[^1] + 111


setPrec(130)  # Default precision is not sufficient.

let vfloat = v[float](100)
let vdecimal = v[DecimalType](100)
let vrational = v[Rat](100)

echo "Task 1"
echo "  n          v(n) float            v(n) decimal           v(n) rational"
for n in [3, 4, 5, 6, 7, 8, 20, 30, 50, 100]:
  echo &"{n:>3}    {vfloat[n]:>20.16f}   {vdecimal[n].format(3, 16)}   {vrational[n].format(3, 16)}"


####################################################################################################
# Task 2.

proc balance[T: float|DecimalType|Rat](): T =
  ## Return the balance after 25 years.
  result = when T is float: E - 1
           elif T is DecimalType: exp(newDecimal(1)) - 1
           else: newInt("17182818284590452353602874713526624977572470") /
                 newInt("10000000000000000000000000000000000000000000")

  var n = when T is float: 1.0 else: 1
  while n <= 25:
    result = result * n - 1
    n += 1

echo "\nTask 2."
echo "Balance after 25 years (float):     ", (&"{balance[float]():.16f}")[0..17]
echo "Balance after 25 years (decimal):   ", balance[DecimalType]().format(1, 16)
echo "Balance after 25 years: (rational): ", balance[Rat]().format(1, 16)


####################################################################################################
# Task 3.

const
  A = 77617
  B = 33096

proc rump[T: float|DecimalType|Rat](a, b: T): T =
  ## Return the value of the Rump's function.
  let C1 = when T is float: 333.75
           elif T is Rat: newRat(333.75)
           else: newDecimal("333.75")
  let C2 = when T is float: 5.5
           elif T is Rat: newRat(5.5)
           else: newDecimal("5.5")
  result = C1 * b^6 + a^2 * (11 * a^2 * b^2 - b^6 - 121 * b^4 - 2) + C2 * b^8 + a / (2 * b)

echo "\nTask 3"

let rumpFloat = rump(A.toFloat, B.toFloat)
let rumpDecimal = rump(newDecimal(A), newDecimal(B))
let rumpRational = rump(newRat(A), newRat(B))

echo &"f({A}, {B}) float =    ", rumpFloat
echo &"f({A}, {B}) decimal =  ", rumpDecimal.format(1, 16)
echo &"f({A}, {B}) rational = ", rumpRational.format(1, 16)
