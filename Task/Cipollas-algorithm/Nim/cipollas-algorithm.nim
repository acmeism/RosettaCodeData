import options
import bignum

let
  Zero = newInt(0)
  One = newInt(1)
  BigBig = newInt(10)^50 + 15

type
  Point = tuple[x, y: Int]
  Solutions = (Int, Int)


proc exp(x, y, m: Int): Int =
  ## Missing function in "bignum" module.
  if m == 1: return Zero
  result = newInt(1)
  var x = x mod m
  var y = y.clone
  while not y.isZero:
    if y mod 2 == 1:
      result = result * x mod m
    y = y shr 1
    x = x * x mod m


proc c(ns, ps: string): Option[Solutions] =
  let n = newInt(ns)
  let p = if ps.len != 0: newInt(ps) else: BigBig

  # Legendre symbol: returns 1, 0 or p - 1.
  proc ls(a: Int): Int = a.exp((p - 1) div 2, p)

  # Step 0, validate arguments.
  if ls(n) != One: return none(Solutions)

  # Step 1, find a, omega2.
  var a = newInt(0)
  var omega2: Int
  while true:
    omega2 = (a * a + p - n) mod p
    if ls(omega2) == p - 1: break
    a += 1

  # Multiplication in Fp2.
  proc `*`(a, b: Point): Point =
    ((a.x * b.x + a.y * b.y * omega2) mod p,
     (a.x * b.y + b.x * a.y) mod p)

  # Step 2, compute power.
  var
    r: Point = (One, Zero)
    s: Point = (a, One)
    nn = ((p + 1) shr 1) mod p
  while not nn.isZero:
    if (nn and One) == One: r = r * s
    s = s * s
    nn = nn shr 1

  # Step 3, check x in Fp.
  if not r.y.isZero: return none(Solutions)

   # Step 5, check x * x = n.
  if r.x * r.x mod p != n: return none(Solutions)

   # Step 4, solutions.
  result = some((r.x, p - r.x))


when isMainModule:

  const Values = [("10", "13"), ("56", "101"), ("8218", "10007"),
                  ("8219", "10007"), ("331575", "1000003"),
                  ("665165880", "1000000007"), ("881398088036", "1000000000039"),
                  ("34035243914635549601583369544560650254325084643201", "")]

  for (n, p) in Values:
    let sols = c(n, p)
    if sols.isSome: echo sols.get()
    else: echo "No solutions."
