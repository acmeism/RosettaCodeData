import rationals, tables

type

  Fraction = Rational[int]

  FpsKind = enum fpsConst, fpsAdd, fpsSub, fpsMul, fpsDiv, fpsDeriv, fpsInteg

  Fps = ref object
    kind: FpsKind
    s1, s2: Fps
    a0: Fraction
    cache: Table[Natural, Fraction]

const

  Zero: Fraction = 0 // 1
  One: Fraction = 1 // 1
  DispTerm = 12
  XVar = "x"
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

func newFps*(val = 0): Fps =
  ## Build a FPS of kind fpsConst using the given integer value.
  Fps(kind: fpsConst, a0: val // 1)

#---------------------------------------------------------------------------------------------------

func newFps*(val: Fraction): Fps =
  ## Build a FPS of kind fpsConst using the given fraction.
  Fps(kind: fpsConst, a0: val)

#---------------------------------------------------------------------------------------------------

func newFps*(op: FpsKind; x: Fps; y: Fps = nil): Fps =
  ## Build a FPS for a unary or binary operation.
  Fps(kind: op, s1: x, s2: y, a0: Zero)

#---------------------------------------------------------------------------------------------------

func redefine*(fps: Fps; other: Fps) =
  ## Redefine a FPS, modifying its kind ans its operands.
  fps.kind = other.kind
  fps.s1 = other.s1
  fps.s2 = other.s2

#---------------------------------------------------------------------------------------------------

## Operations on FPS.
func `+`*(x, y: Fps): Fps = newFps(fpsAdd, x, y)
func `-`*(x, y: Fps): Fps = newFps(fpsSub, x, y)
func `*`*(x, y: Fps): Fps = newFps(fpsMul, x, y)
func `/`*(x, y: Fps): Fps = newFps(fpsDiv, x, y)
func derivative*(x: Fps): Fps = newFps(fpsDeriv, x)
func integral*(x: Fps): Fps = newFps(fpsInteg, x)

#---------------------------------------------------------------------------------------------------

func `[]`*(fps: Fps; n: Natural): Fraction =
  ## Return the nth term of the FPS.

  if n in fps.cache: return fps.cache[n]

  case fps.kind

  of fpsConst:
    result = if n > 0: Zero else: fps.a0

  of fpsAdd:
    result = fps.s1[n] + fps.s2[n]

  of fpsSub:
    result = fps.s1[n] - fps.s2[n]

  of fpsMul:
    result = Zero
    for i in 0..n: result += fps.s1[i] * fps.s2[n - i]

  of fpsDiv:
    let d = fps.s2[0]
    if d == Zero: raise newException(DivByZeroDefect, "Division by null fraction")
    result = fps.s1[n]
    for i in 1..n: result -= fps.s2[i] * fps[n - i] / d

  of fpsDeriv:
    result = fps.s1[n + 1] * (n + 1)

  of fpsInteg:
    result = if n > 0: fps.s1[n - 1] / n else: fps.a0

  fps.cache[n] = result

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
var cos = newFps()
let sin = cos.integral()
let tan = sin / cos
cos.redefine(newFps(1) - sin.integral())
echo "sin(x) = ", sin
echo "cos(x) = ", cos
echo "tan(x) = ", tan

# Check that derivative of sin is cos.
echo "derivative of sin(x) = ", sin.derivative()

# Build exp using recursion.
let exp = newFps()
exp.redefine(newFps(1) + exp.integral())
echo "exp(x) = ", exp
