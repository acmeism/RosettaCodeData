import strformat

const
  Emx = 64        # Exponent maximum.
  Amx = 6000      # Argument maximum.
  PMax = 32749    # Prime maximum.

type

  Ratio = tuple[a, b: int]

  Padic = object
    p: int                        # Prime.
    k: int                        # Precision.
    v: int
    d: array[-Emx..(Emx-1), int]

  PadicError = object of ValueError


proc sqrt(pa: var Padic; q: Ratio; sw: bool) =
  ## Return the p-adic square root of q = a/b. Set sw to print.

  var (a, b) = q
  var i, x: int

  if b == 0:
    raise newException(PadicError, &"Wrong rational: {a}/{b}" )
  if b < 0:
    b = -b
    a = -a
  if pa.p  < 2:
    raise newException(PadicError, &"Wrong value for p: {pa.p}")
  if pa.k < 1:
    raise newException(PadicError, &"Wrong value for k: {pa.k}")
  pa.p = min(pa.p, PMax)      # Maximum short prime.

  if sw: echo &"{a}/{b} + 0({pa.p}^{pa.k})"

  # Initialize.
  pa.v = 0
  pa.d.reset()
  if a == 0: return

  # Valuation.
  while b mod pa.p == 0:
    b = b div pa.p
    dec pa.v
  while a mod pa.p == 0:
    a = a div pa.p
    inc pa.v
  if (pa.v and 1) != 0:
    # Odd valuation.
    raise newException(PadicError, &"Non-residue mod {pa.p}.")

  # Maximum array length.
  pa.k = min(pa.k + pa.v, Emx - 1) - pa.v
  pa.v = pa.v shr 1

  if abs(a) > Amx or b > Amx:
    raise newException(PadicError, &"Rational exceeding limits: {a}/{b}.")

  if pa.p == 2:
    # 1 / b = b (mod 8); a / b = 1 (mod 8).
    if (a * b and 7) - 1 != 0:
      raise newException(PadicError, "Non-residue mod 8.")

    # Initialize.
    x = 1
    pa.d[pa.v] = 1
    pa.d[pa.v + 1] = 0
    var pk = 4
    i = pa.v + 2
    while i < pa.k + pa.v:
      pk *= 2
      let f = b * x * x - a
      let q = f div pk
      if f != q * pk: break   # Overflow.
      # Next digit.
      pa.d[i] = if (q and 1) != 0: 1 else: 0
      # Lift "x".
      x += pa.d[i] * (pk shr 1)
      inc i

  else:
    # Find root for small "p".
    var r = 1
    while r < pa.p:
      if (b * r * r - a) mod pa.p == 0: break
      inc r
    if r == pa.p:
      raise newException(PadicError, &"Non-residue mod {pa.p}.")
    let t = (b * r shl 1) mod pa.p
    var s = 0

    # Modular inverse for small "p".
    var f1 = 1
    while f1 < pa.p:
      inc s, t
      if s >= pa.p: dec s, pa.p
      if s == 1: break
      inc f1
    if f1 == pa.p:
      raise newException(PadicError, "Impossible to compute inverse modulo")

    f1 = pa.p - f1
    x = r
    pa.d[pa.v] = x

    var pk = 1
    i = pa.v + 1
    while i < pa.k + pa.v:
      pk *= pa.p
      let f = b * x * x - a
      let q = f div pk
      if f != q * pk: break   # Overflow.
      pa.d[i] = q * f1 mod pa.p
      if pa.d[i] < 0: pa.d[i] += pa.p
      x += pa.d[i] * pk
      inc i

  pa.k = i - pa.v
  if sw: echo &"lift: {x} mod {pa.p}^{pa.k}"


proc crat(pa: Padic; sw: bool): Ratio =
  ## Rational reconstruction.

  # Weighted digit sum.
  var
    s = 0
    pk = 1
  for i in min(pa.v, 0)..<(pa.k + pa.v):
    let pm = pk
    pk *= pa.p
    if pk div pm - pa.p != 0:
      # Overflow.
      pk = pm
      break
    s += pa.d[i] * pm

  # Lattice basis reduction.
  var
    m = [pk, s]
    n = [0, 1]
    i = 0
    j = 1
  s = s * s + 1
  # Lagrange's algorithm.
  while true:
    # Euclidean step.
    var q = ((m[i] * m[j] + n[i] * n[j]) / s).toInt
    m[i] -= q * m[j]
    n[i] -= q * n[j]
    q = s
    s = m[i] * m[i] + n[i] * n[i]
    # Compare norms.
    if s < q: swap i, j   # Interchange vectors.
    else: break

  var x = m[j]
  var y = n[j]
  if y < 0:
    y = -y
    x = -x

  # Check determinant.
  if abs(m[i] * y - x * n[i]) != pk:
    raise newException(PadicError, "Rational reconstruction failed.")

  # Negative powers.
  for i in pa.v..(-1): y *= pa.p

  if sw: echo x, if y > 1: '/' & $y else: ""
  result = (x, y)


func cmpt(pa: Padic): Padic =
  ## Return the complement.
  result = Padic(p: pa.p, k: pa.k, v: pa.v)
  var c = 1
  for i in pa.v..(pa.k + pa.v):
    inc c, pa.p - 1 - pa.d[i]
    if c >= pa.p:
      result.d[i] = c - pa.p
      c = 1
    else:
      result.d[i] = c
      c = 0


func sqr(pa: Padic): Padic =
  ## Return the square of a P-adic number.
  result = Padic(p: pa.p, k: pa.k, v: pa.v * 2)
  var c = 0
  for i in 0..pa.k:
    for j in 0..i:
      c += pa.d[pa.v + j] * pa.d[pa.v + i - j]
    # Euclidean step.
    let q = c div pa.p
    result.d[result.v + i] = c - q * pa.p
    c = q


func `$`(pa: Padic): string =
  ## String representation.
  let t = min(pa.v, 0)
  for i in countdown(pa.k - 1 + t, t):
    result.add $pa.d[i]
    if i == 0 and pa.v < 0: result.add "."
    result.add " "


when isMainModule:

  const Data = [[-7, 1, 2, 7],
                [9, 1, 2, 8],
                [17, 1, 2, 9],
                [497, 10496, 2, 18],
                [10496, 497, 2, 19],
                [3141, 5926, 3, 15],
                [2718,  281, 3, 13],
                [-1,  1,  5, 8],
                [86, 25,  5, 8],
                [2150, 1,  5, 8],
                [2,1, 7, 8],
                [-2645, 28518, 7, 9],
                [3029, 4821, 7, 9],
                [379, 449, 7, 8],
                [717, 8, 11, 7],
                [1414, 213, 41, 5],
                [-255, 256, 257, 3]]

  for d in Data:
    try:
      let q: Ratio = (d[0], d[1])
      var a = Padic(p: d[2], k: d[3])
      a.sqrt(q, true)
      echo "sqrt +/-"
      echo "...", a
      a = a.cmpt()
      echo "...", a
      let c = sqr(a)
      echo "sqrt^2"
      echo "   ", c
      let r = c.crat(true)
      if q.a * r.b - r.a * q.b != 0:
        echo "fail: sqrt^2"
      echo ""
    except PadicError:
      echo getCurrentExceptionMsg()
