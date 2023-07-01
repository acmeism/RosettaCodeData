import math, random, strformat

const
  MaxN = 1073741789       # Maximum modulus.
  MaxR = MaxN + 65536     # Maximum order "g".
  Infinity = int64.high   # Symbolic infinity.

type

  Point = tuple[x, y: int64]

  Curve = object
    a, b: int64
    n: int64
    g: Point
    r: int64

  Pair = tuple[a, b: int64]

  Parameters = tuple[a, b, n, gx, gy, r: int]

const ZerO: Point = (Infinity, 0i64)

type
  InversionError = object of ValueError
  InvalidParamError = object of ValueError


template `%`(a, n: int64): int64 =
  ## To simplify the writing.
  floorMod(a, n)


proc exgcd(v, u: int64): int64 =
  ## Return 1/v mod u.
  var u = u
  var v = v
  if v < 0: v += u

  var r = 0i64
  var s = 1i64
  while v != 0:
    let q = u div v
    u = u mod v
    swap u, v
    r -= q * s
    swap r, s

  if u != 1:
    raise newException(InversionError, "impossible inverse mod N, gcd = " & $u)
  result = r


func discr(e: Curve): int64 =
  ## Return the discriminant of "e".
  let c = e.a * e.a % e.n * e.a % e.n * 4
  result = -16 * (e.b * e.b % e.n * 27 + c) % e.n


func isO(p: Point): bool =
  ## Return true if "p" is zero.
  p.x == Infinity and p.y == 0


func isOn(e: Curve; p: Point): bool =
  ## Return true if "p" is on curve "e".
  if p.isO: return true
  let r = ((e.a + p.x * p.x) % e.n * p.x + e.b) % e.n
  let s = p.y * p.y % e.n
  result = r == s


proc add(e: Curve; p, q: Point): Point =
  ## Full Point addition.

  if p.isO: return q
  if q.isO: return p

  var la: int64
  if p.x != q.x:
    la = (p.y - q.y) * exgcd(p.x - q.x, e.n) % e.n
  elif p.y == q.y and p.y != 0:
    la = (p.x * p.x % e.n * 3 + e.a) % e.n * exgcd(2 * p.y, e.n) % e.n
  else:
    return ZerO

  result.x = (la * la - p.x - q.x) % e.n
  result.y = (la * (p.x - result.x) - p.y) % e.n


proc mul(e: Curve; p: Point; k: int64): Point =
  ## Return "kp".
  var q = p
  var k = k
  result = ZerO

  while k != 0:
    if (k and 1) != 0:
      result = e.add(result, q)
    q = e.add(q, q)
    k = k shr 1


proc print(e: Curve; prefix: string; p: Point) =
  ## Print a point with a prefix.
  var y = p.y
  if p.isO:
    echo prefix, " (0)"
  else:
    if y > e.n - y: y -= e.n
    echo prefix, &" ({p.x}, {y})"


proc initCurve(params: Parameters): Curve =
  ## Initialize the curve.

  result.n = params.n
  if result.n notin 5..MaxN:
    raise newException(ValueError, "invalid value for N: " & $result.n)
  result.a = params.a.int64 % result.n
  result.b = params.b.int64 % result.n
  result.g.x = params.gx.int64 % result.n
  result.g.y = params.gy.int64 % result.n
  result.r = params.r

  if result.r notin 5..MaxR:
    raise newException(ValueError, "invalid value for r: " & $result.r)

  echo &"\nE: y^2 = x^3 + {result.a}x + {result.b} (mod {result.n})"
  result.print("base point G", result.g)
  echo &"order(G, E) = {result.r}"


proc rnd(): float =
  ## Return a pseudorandom number in range [0..1[.
  while true:
    result = rand(1.0)
    if result != 1: break

proc signature(e: Curve; s, f: int64): Pair =
  ## Compute the signature.

  var
    c, d = 0i64
    u: int64
    v: Point

  echo "Signature computation"

  while true:
    while true:
      u = 1 + int64(rnd() * float(e.r - 1))
      v = e.mul(e.g, u)
      c = v.x % e.r
      if c != 0: break
    d = exgcd(u, e.r) * (f + s * c % e.r) % e.r
    if d != 0: break

  echo "one-time u = ", u
  e.print("V = uG", v)

  result = (c, d)


proc verify(e: Curve; w: Point; f: int64; sg: Pair): bool =
  ## Verify a signature.

  # Domain check.
  if sg.a notin 1..<e.r or sg.b notin 1..<e.r:
    return false

  echo "\nsignature verification"
  let h = exgcd(sg.b, e.r)
  let h1 = f * h % e.r
  let h2 = sg.a * h % e.r
  echo &"h1, h2 = {h1}, {h2}"
  var v = e.mul(e.g, h1)
  let v2 = e.mul(w, h2)
  e.print("h1G", v)
  e.print("h2W", v2)
  v = e.add(v, v2)
  e.print("+ =", v)
  if v.isO: return false
  let c1 = v.x % e.r
  echo "c’ = ", c1
  result = c1 == sg.a


proc ecdsa(e: Curve; f: int64; d: int) =
  ## Build digital signature for message hash "f" with error bit "d".

  # Parameter check.
  var w = e.mul(e.g, e.r)
  if e.discr() == 0 or e.g.isO or not w.isO or not e.isOn(e.g):
    raise newException(InvalidParamError, "invalid parameter set")

  echo "\nkey generation"
  let s = 1 + int64(rnd() * float(e.r - 1))
  w = e.mul(e.g, s)
  echo "private key s = ", s
  e.print("public key W = sG", w)

  # Find next highest power of two minus one.
  var t = e.r
  var i = 1
  while i < 64:
    t = t or t shr i
    i = i shl 1
  var f = f
  while f > t: f = f shr 1
  echo &"\naligned hash {f:x}"

  let sg = e.signature(s, f)
  echo &"signature c, d = {sg.a}, {sg.b}"

  var d = d
  if d > 0:
    while d > t: d = d shr 1
    f = f xor d
    echo &"\ncorrupted hash {f:x}"

  echo if e.verify(w, f, sg): "Valid" else: "Invalid"

when isMainModule:

  randomize()

  # Test vectors: elliptic curve domain parameters,
  # short Weierstrass model y^2 = x^3 + ax + b (mod N)

  const Sets = [
    #    a,   b,  modulus N, base point G, order(G, E), cofactor
      (355, 671, 1073741789, 13693, 10088, 1073807281),
      (  0,   7,   67096021,  6580,   779,   16769911),
      ( -3,   1,     877073,     0,     1,     878159),
      (  0,  14,      22651,    63,    30,        151),
      (  3,   2,          5,     2,     1,          5),

    # ECDSA may fail if...
    # the base point is of composite order
      (  0,   7,   67096021,  2402,  6067,   33539822),
    # the given order is of composite order
      (  0,   7,   67096021,  6580,   779,   67079644),
    # the modulus is not prime (deceptive example)
      (  0,   7,     877069,     3, 97123,     877069),
    # fails if the modulus divides the discriminant
      ( 39, 387,      22651,    95,    27,      22651)
    ]

  # Digital signature on message hash f,
  # set d > 0 to simulate corrupted data.
  let f = 0x789abcdei64
  let d = 0

  for s in Sets:
    let e = initCurve(s)
    try:
      e.ecdsa(f, d)
    except ValueError:
      echo getCurrentExceptionMsg()
    echo "——————————————"
