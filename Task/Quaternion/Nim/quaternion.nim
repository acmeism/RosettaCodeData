import math, tables

type Quaternion* = object
  a, b, c, d: float

func initQuaternion*(a, b, c, d = 0.0): Quaternion =
  Quaternion(a: a, b: b, c: c, d: d)

func `-`*(q: Quaternion): Quaternion =
  initQuaternion(-q.a, -q.b, -q.c, -q.d)

func `+`*(q: Quaternion; r: float): Quaternion =
  initQuaternion(q.a + r, q.b, q.c, q.d)

func `+`*(r: float; q: Quaternion): Quaternion =
  initQuaternion(q.a + r, q.b, q.c, q.d)

func `+`*(q1, q2: Quaternion): Quaternion =
  initQuaternion(q1.a + q2.a, q1.b + q2.b, q1.c + q2.c, q1.d + q2.d)

func `*`*(q: Quaternion; r: float): Quaternion =
  initQuaternion(q.a * r, q.b * r, q.c * r, q.d * r)

func `*`*(r: float; q: Quaternion): Quaternion =
  initQuaternion(q.a * r, q.b * r, q.c * r, q.d * r)

func `*`*(q1, q2: Quaternion): Quaternion =
  initQuaternion(q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,
                 q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,
                 q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,
                 q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a)

func conjugate*(q: Quaternion): Quaternion =
  initQuaternion(q.a, -q.b, -q.c, -q.d)

func norm*(q: Quaternion): float =
  sqrt(q.a * q.a + q.b * q.b + q.c * q.c + q.d * q.d)

func `==`*(q: Quaternion; r: float): bool =
  if q.b != 0 or q.c != 0 or q.d != 0: false
  else: q.a == r

func `$`(q: Quaternion): string =
  ## Return the representation of a quaternion.
  const Letter = {"a": "", "b": "i", "c": "j", "d": "k"}.toTable
  if q == 0: return "0"
  for name, value in q.fieldPairs:
    if value != 0:
      var val = value
      if result.len != 0:
        result.add if value >= 0: '+' else: '-'
        val = abs(val)
      result.add $val & Letter[name]


when isMainModule:
  let
    q = initQuaternion(1, 2, 3, 4)
    q1 = initQuaternion(2, 3, 4, 5)
    q2 = initQuaternion(3, 4, 5, 6)
    r = 7.0

  echo "∥q∥ = ", norm(q)
  echo "-q = ", -q
  echo "q* = ", conjugate(q)
  echo "q + r = ", q + r
  echo "r + q = ", r + q
  echo "q1 + q2 = ", q1 + q2
  echo "qr = ", q * r
  echo "rq = ", r * q
  echo "q1 * q2 = ", q1 * q2
  echo "q2 * q1 = ", q2 * q1
