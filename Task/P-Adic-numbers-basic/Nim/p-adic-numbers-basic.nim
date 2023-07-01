import math, strformat

const
  Emx = 64        # Exponent maximum.
  Dmx = 100000    # Approximation loop maximum.
  Amx = 1048576   # Argument maximum.
  PMax = 32749    # Prime maximum.

type

  Ratio = tuple[a, b: int]

  Padic = object
    p: int                        # Prime.
    k: int                        # Precision.
    v: int
    d: array[-Emx..(Emx-1), int]

  PadicError = object of ValueError


proc r2pa(pa: var Padic; q: Ratio; sw: bool) =
  ## Convert "q" to p-adic number, set "sw" to print.

  var (a, b) = q

  if b == 0:
    raise newException(PadicError, &"Wrong rational: {a}/{b}" )
  if b < 0:
    b = -b
    a = -a
  if abs(a) > Amx or b > Amx:
    raise newException(PadicError, &"Rational exceeding limits: {a}/{b}")
  if pa.p  < 2:
    raise newException(PadicError, &"Wrong value for p: {pa.p}")
  if pa.k < 1:
    raise newException(PadicError, &"Wrong value for k: {pa.k}")
  pa.p = min(pa.p, PMax)      # Maximum short prime.
  pa.k = min(pa.k, Emx - 1)   # Maximum array length.

  if sw: echo &"{a}/{b} + 0({pa.p}^{pa.k})"

  # Initialize.
  pa.v = 0
  pa.d.reset()
  if a == 0: return
  var i = 0

  # Find -exponent of "p" in "b".
  while b mod pa.p == 0:
    b = b div pa.p
    dec i

  var s = 0
  var r = b mod pa.p

  # Modular inverse for small "p".
  var b1 = 1
  while b1 < pa.p:
    inc s, r
    if s >= pa.p: dec s, pa.p
    if s == 1: break
    inc b1
  if b1 == pa.p:
    raise newException(PadicError, "Impossible to compute inverse modulo")
  pa.v = Emx
  while true:
    # Find exponent of "p" in "a".
    while a mod pa.p == 0:
      a = a div pa.p
      inc i
    # Valuation.
    if pa.v == Emx: pa.v = i
    # Upper bound.
    if i >= Emx: break
    # Check precision.
    if i - pa.v > pa.k: break
    # Next digit.
    pa.d[i] = floorMod(a * b1, pa.p)
    # Remainder - digit * divisor.
    dec a, pa.d[i] * b
    if a == 0: break


func dsum(pa: Padic): int =
  ## Horner's rule.
  let t = min(pa.v, 0)
  for i in countdown(pa.k - 1 + t, t):
    var r = result
    result *= pa.p
    if r != 0 and (result div r - pa.p) != 0:
      return -1    # Overflow.
    inc result, pa.d[i]


func `+`(pa, pb: Padic): Padic =
  ## Add two p-adic numbers.
  assert pa.p == pb.p and pa.k == pb.k
  result.p = pa.p
  result.k = pa.k
  var c = 0
  result.v = min(pa.v, pb.v)
  for i in result.v..(pa.k + result.v):
    inc c, pa.d[i] + pb.d[i]
    if c >= pa.p:
      result.d[i] = c - pa.p
      c = 1
    else:
      result.d[i] = c
      c = 0


func cmpt(pa: Padic): Padic =
  ## Return the complement.
  var c = 1
  result.p = pa.p
  result.k = pa.k
  result.v = pa.v
  for i in pa.v..(pa.k + pa.v):
    inc c, pa.p - 1 - pa.d[i]
    if c >= pa.p:
      result.d[i] = c - pa.p
      c = 1
    else:
      result.d[i] = c
      c = 0


func crat(pa: Padic): string =
  ## Rational reconstruction.
  var s = pa

  # Denominator count.
  var i = 1
  var fl = false
  while i <= Dmx:
    # Check for integer.
    var j = pa.k - 1 + pa.v
    while j >= pa.v:
      if s.d[j] != 0: break
      dec j
    fl = (j - pa.v) * 2 < pa.k
    if fl:
      fl = false
      break
    # Check negative integer.
    j = pa.k - 1 + pa.v
    while j >= pa.v:
      if pa.p - 1 - s.d[j] != 0: break
      dec j
    fl = (j - pa.v) * 2 < pa.k
    if fl: break
    # Repeatedly add "pa" to "s".
    s = s + pa
    inc i

  if fl: s = s.cmpt()

  # Numerator: weighted digit sum.
  var x = s.dsum()
  var y = i
  if x < 0 or y > Dmx:
    raise newException(PadicError, &"Error during rational reconstruction: {x}, {y}")
  # Negative powers.
  for i in pa.v..(-1): y *= pa.p
  # Negative rational.
  if fl: x = -x
  result = $x
  if y > 1: result.add &"/{y}"


func `$`(pa: Padic): string =
  ## String representation.
  let t = min(pa.v, 0)
  for i in countdown(pa.k - 1 + t, t):
    result.add $pa.d[i]
    if i == 0 and pa.v < 0: result.add "."
    result.add " "


proc print(pa: Padic; sw: int) =
  echo pa
  # Rational approximation.
  if sw != 0: echo pa.crat()


when isMainModule:

  # Rational reconstruction depends on the precision
  # until the dsum-loop overflows.
  const Data = [[2, 1, 2, 4, 1, 1],
                [4, 1, 2, 4, 3, 1],
                [4, 1, 2, 5, 3, 1],
                [4, 9, 5, 4, 8, 9],
                [26, 25, 5, 4, -109, 125],
                [49, 2, 7, 6, -4851, 2],
                [-9, 5, 3, 8, 27, 7],
                [5, 19, 2, 12, -101, 384],
                # Two decadic pairs.
                [2, 7, 10, 7, -1, 7],
                [34, 21, 10, 9, -39034, 791],
                # Familiar digits.
                [11, 4, 2, 43, 679001, 207],
                [-8, 9, 23, 9, 302113, 92],
                [-22, 7, 3, 23, 46071, 379],
                [-22, 7, 32749, 3, 46071, 379],
                [35, 61, 5, 20, 9400, 109],
                [-101, 109, 61, 7, 583376, 6649],
                [-25, 26, 7, 13, 5571, 137],
                [1, 4, 7, 11, 9263, 2837],
                [122, 407, 7, 11, -517, 1477],
                # More subtle.
                [5, 8, 7, 11, 353, 30809]]

  for d in Data:
    try:
      var a, b = Padic(p: d[2], k: d[3])
      r2pa(a, (d[0], d[1]), true)
      print(a, 0)
      r2pa(b, (d[4], d[5]), true)
      print(b, 0)
      echo "+ ="
      print(a + b, 1)
      echo ""
    except PadicError:
      echo getCurrentExceptionMsg()
