import rationals, sequtils

type

  Fraction = Rational[int]

  # Function to compute coefficients.
  CoeffFunc = proc(n: int): Fraction

  # Formal power series.
  Fps = ref object
    cache: seq[Fraction]  # Cache to store values.
    coeffs: CoeffFunc     # Function to compute coefficients.

const
  Zero: Fraction = 0 // 1
  One: Fraction = 1 // 1
  XVar = "x"
  DispTerm = 12
  Super: array['0'..'9', string] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]


#---------------------------------------------------------------------------------------------------

proc `$`(fract: Fraction): string =
  ## Return the representation of a fraction without the denominator if it is equal to 1.
  if fract.den == 1: $fract.num else: rationals.`$`(fract)

#---------------------------------------------------------------------------------------------------

proc exponent(n: Natural): string =
  ## Return the representation of an exponent using unicode superscript.
  if n == 1: return ""
  for d in $n: result.add(Super[d])


####################################################################################################
# FPS.

func newFps*(coeffs: CoeffFunc): Fps =
  ## Create a FPS using the given "coeffs" function.
  Fps(coeffs: coeffs)

#---------------------------------------------------------------------------------------------------

func newFps*(coeffs: seq[Fraction]): Fps =
  ## Create a FPS using a list of fractions to initialize coefficients.
  Fps(coeffs: proc(n: int): Fraction = (if n in 0..coeffs.high: coeffs[n] else: Zero))

#---------------------------------------------------------------------------------------------------

func newFps*(coeffs: seq[int]): Fps =
  ## Create a FPS using a list of integer values to initialize coefficients.
  Fps(coeffs: proc(n: int): Fraction = (if n in 0..coeffs.high: coeffs[n] // 1 else: Zero))

#---------------------------------------------------------------------------------------------------

func copyFrom(dest, src: Fps) {.inline.} =
  ## Copy a FPS into another.
  dest[] = src[]

#---------------------------------------------------------------------------------------------------

proc `[]`*(fps: Fps; n: int): Fraction =
  ## Return the element of degree "n" from a FPS.

  if n < 0: return Zero
  for i in fps.cache.len..n:
    fps.cache.add(fps.coeffs(i))
  result = fps.cache[n]

#---------------------------------------------------------------------------------------------------

proc inverseCoeff*(fps: FPS; n: int): Fraction =
  ## Return the inverse coefficient of coefficient of degree "n".

  var res = repeat(Zero, n + 1)
  res[0] = fps[0].reciprocal
  for i in 1..n:
    for j in 0..<i: res[i] += fps[i - j] * res[j]
    res[i] *= -res[0]
  result = res[n]

#---------------------------------------------------------------------------------------------------

proc `+`*(a, b: Fps): Fps =
  ## Build the FPS sum of two FPS.
  Fps(coeffs: proc(n: int): Fraction = a[n] + b[n])

#---------------------------------------------------------------------------------------------------

proc `-`*(a, b: Fps): Fps =
  ## Build the FPS difference of two FPS.
  Fps(coeffs: proc(n: int): Fraction = a[n] - b[n])

#---------------------------------------------------------------------------------------------------

proc `*`*(a, b: Fps): Fps =
  ## Build the FPS product of two FPS.
  Fps(coeffs: proc(n: int): Fraction =
                result = Zero
                for i in 0..n: result += a[i] * b[n - i])

#---------------------------------------------------------------------------------------------------

proc `/`*(a, b: Fps): Fps =
  ## Build the FPS quotient of two FPS.
  Fps(coeffs: proc(n: int): Fraction =
                result = Zero
                for i in 0..n: result += a[i] * b.inverseCoeff(n - i))

#---------------------------------------------------------------------------------------------------

proc derivative*(fps: Fps): Fps =
  ## Build the FPS derivative of a FPS.
  Fps(coeffs: proc(n: int): Fraction = fps[n + 1] * (n + 1))

#---------------------------------------------------------------------------------------------------

proc integral*(fps: Fps): Fps =
  ## Build the FPS integral of a FPS.
  Fps(coeffs: proc(n: int): Fraction = (if n == 0: Zero else: fps[n - 1] / n))

#---------------------------------------------------------------------------------------------------

proc `$`*(fps: Fps): string =
  ## Return the representation of a FPS.

  var c = fps[0]
  if c != Zero: result &= $c

  for i in 1..<DispTerm:
    c = fps[i]
    if c != Zero:
      if c > Zero:
        if result.len > 0: result &= " + "
      else:
        result &= " - "
        c = -c
      result &= (if c == One: XVar else: $c & XVar) & exponent(i)

  if result.len == 0: result &= '0'
  result &= " + ..."

#———————————————————————————————————————————————————————————————————————————————————————————————————

# Build cos, sin and tan.
var cos = Fps()
let sin = cos.integral()
cos.copyFrom(newFps(@[1]) - sin.integral())
let tan = sin / cos
echo "sin(x) = ", sin
echo "cos(x) = ", cos
echo "tan(x) = ", tan

# Check that derivative of sin is cos.
echo "derivative of sin(x) = ", sin.derivative()

# Build exp using recursion.
let exp = Fps()
exp.copyFrom(newFps(@[1]) + exp.integral())
echo "exp(x) = ", exp
