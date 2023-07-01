proc pow*[T: SomeInteger](x, n, p: T): T =
  var t = x mod p
  var e = n
  result = 1
  while e > 0:
    if (e and 1) == 1:
      result = result * t mod p
    t = t * t mod p
    e = e shr 1

proc legendre*[T: SomeInteger](a, p: T): T = pow(a, (p-1) shr 1, p)

proc tonelliShanks*[T: SomeInteger](n, p: T): T =
  # Check that n is indeed a square.
  if legendre(n, p) != 1:
    raise newException(ValueError, "Not a square")

  # Factor out power of 2 from p-1.
  var q = p - 1
  var s = 0
  while (q and 1) == 0:
    s += 1
    q = q shr 1

  if s == 1:
    return pow(n, (p+1) shr 2, p)

  # Select a non-square z such as (z | p) = -1.
  var z = 2
  while legendre(z, p) != p - 1:
    z += 1

  var
    c = pow(z, q, p)
    t = pow(n, q, p)
    m = s
  result = pow(n, (q+1) shr 1, p)
  while t != 1:
    var
      i = 1
      z = t * t mod p
    while z != 1 and i < m-1:
      i += 1
      z = z * z mod p

    var b = pow(c, 1 shl (m-i-1), p)
    c = b * b mod p
    t = t * c mod p
    m = i
    result = result * b mod p

when isMainModule:
  proc run(n, p: SomeInteger) =
    try:
      let r = tonelliShanks(n, p)
      echo r, " ", p-r
    except ValueError:
      echo getCurrentExceptionMsg()

  run(10, 13)
  run(56, 101)
  run(1030, 10009)
  run(1032, 10009)
  run(44402, 100049)
  run(665820697, 1000000009)
