import strformat

####################################################################################################

type MatrixNG = ref object of RootObj
  cfn: int
  thisTerm: int
  haveTerm: bool

method consumeTerm(m: MatrixNG) {.base.} =
  raise newException(CatchableError, "Method without implementation override")

method consumeTerm(m: MatrixNG; n: int) {.base.} =
  raise newException(CatchableError, "Method without implementation override")

method needTerm(m: MatrixNG): bool {.base.} =
  raise newException(CatchableError, "Method without implementation override")


####################################################################################################

type NG4 = ref object of MatrixNG
  a1, a, b1, b: int

proc newNG4(a1, a, b1, b: int): NG4 =
  NG4(a1: a1, a: a, b1: b1, b: b)

method needTerm(ng: NG4): bool =
  if ng.b1 == 0 and ng.b == 0: return false
  if ng.b1 == 0 or ng.b == 0: return true
  ng.thisTerm = ng.a div ng.b
  if ng.thisTerm == ng.a1 div ng.b1:
    ng.a -= ng.b * ng.thisTerm; swap ng.a, ng.b
    ng.a1 -= ng.b1 * ng.thisTerm; swap ng.a1, ng.b1
    ng.haveTerm = true
    return false
  return true

method consumeTerm(ng: NG4) =
  ng.a = ng.a1
  ng.b = ng.b1

method consumeTerm(ng: NG4; n: int) =
  ng.a += ng.a1 * n; swap ng.a, ng.a1
  ng.b += ng.b1 * n; swap ng.b, ng.b1


####################################################################################################

type NG8 = ref object of MatrixNG
  a12, a1, a2, a: int
  b12, b1, b2, b: int

proc newNG8(a12, a1, a2, a, b12, b1, b2, b: int): NG8 =
  NG8(a12: a12, a1: a1, a2: a2, a: a, b12: b12, b1: b1, b2: b2, b: b)


method needTerm(ng: NG8): bool =
  if ng.b1 == 0 and ng.b == 0 and ng.b2 == 0 and ng.b12 == 0: return false
  if ng.b == 0:
    ng.cfn = ord(ng.b2 != 0)
    return true
  if ng.b2 == 0:
    ng. cfn = 1
    return true
  if ng.b1 == 0:
    ng.cfn = 0
    return true

  let
    ab = ng.a / ng.b
    a1b1 = ng.a1 / ng.b1
    a2b2 = ng.a2 / ng.b2
  if ng.b12 == 0:
    ng.cfn = ord(abs(a1b1 - ab) <= abs(a2b2 - ab))
    return true

  ng.thisTerm = int(ab)
  if ng.thisTerm == int(a1b1) and ng.thisTerm == int(a2b2) and ng.thisTerm == ng.a12 div ng.b12:
    ng.a -= ng.b * ng.thisTerm; swap ng.a, ng.b
    ng.a1 -= ng.b1 * ng.thisTerm; swap ng.a1, ng.b1
    ng.a2 -= ng.b2 * ng.thisTerm; swap ng.a2, ng.b2
    ng.a12 -= ng.b12 * ng.thisTerm; swap ng.a12, ng.b12
    ng.haveTerm = true
    return false

  ng.cfn = ord(abs(a1b1 - ab) <= abs(a2b2 - ab))
  result = true


method consumeTerm(ng: NG8) =
  if ng.cfn == 0:
    ng.a = ng.a1
    ng.a2 = ng.a12
    ng.b = ng.b1
    ng.b2 = ng.b12
  else:
    ng.a = ng.a2
    ng.a1 = ng.a12
    ng.b = ng.b2
    ng.b1 = ng.b12

method consumeTerm(ng: NG8; n: int) =
  if ng.cfn == 0:
    ng.a += ng.a1 * n; swap ng.a, ng.a1
    ng.a2 += ng.a12 * n; swap ng.a2, ng.a12
    ng.b += ng.b1 * n; swap ng.b, ng.b1
    ng.b2 += ng.b12 * n; swap ng.b2, ng.b12
  else:
    ng.a += ng.a2 * n; swap ng.a, ng.a2
    ng.a1 += ng.a12 * n; swap ng.a1, ng.a12
    ng.b += ng.b2 * n; swap ng.b, ng.b2
    ng.b1 += ng.b12 * n; swap ng.b1, ng.b12


####################################################################################################

type ContinuedFraction = ref object of RootObj

method nextTerm(cf: ContinuedFraction): int {.base.} =
  raise newException(CatchableError, "Method without implementation override")

method moreTerms(cf: ContinuedFraction): bool {.base.} =
  raise newException(CatchableError, "Method without implementation override")


####################################################################################################

type R2Cf = ref object of ContinuedFraction
  n1, n2: int

proc newR2Cf(n1, n2: int): R2Cf =
  R2Cf(n1: n1, n2: n2)

method nextTerm(x: R2Cf): int =
  result = x.n1 div x.n2
  x.n1 -= result * x.n2
  swap x.n1, x.n2

method moreTerms(x: R2Cf): bool =
  abs(x.n2) > 0


####################################################################################################

type NG = ref object of ContinuedFraction
  ng: MatrixNG
  n: seq[ContinuedFraction]

proc newNG(ng: NG4; n1: ContinuedFraction): NG =
  NG(ng: ng, n: @[n1])

proc newNG(ng: NG8; n1, n2: ContinuedFraction): NG =
  NG(ng: ng, n: @[n1, n2])

method nextTerm(x: NG): int =
  x.ng.haveTerm = false
  result = x.ng.thisTerm

method moreTerms(x: NG): bool =
  while x.ng.needTerm():
    if x.n[x.ng.cfn].moreTerms():
      x.ng.consumeTerm(x.n[x.ng.cfn].nextTerm())
    else:
      x.ng.consumeTerm()
  result = x.ng.haveTerm


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  proc test(desc: string; cfs: varargs[ContinuedFraction]) =
    echo &"TESTING → {desc}"
    for cf in cfs:
      while cf.moreTerms(): stdout.write &"{cf.nextTerm()} "
      echo()
    echo()

  let
    a = newNG8(0, 1, 1, 0, 0, 0, 0, 1)
    n2 = newR2Cf(22, 7)
    n1 = newR2Cf(1, 2)
    a3 = newNG4(2, 1, 0, 2)
    n3 = newR2cf(22, 7)
  test("[3;7] + [0;2]", newNG(a, n1, n2), newNG(a3, n3))

  let
    b  = newNG8(1, 0, 0, 0, 0, 0, 0, 1)
    b1 = newR2cf(13, 11)
    b2 = newR2cf(22, 7)
  test("[1;5,2] * [3;7]", newNG(b, b1, b2), newR2cf(286, 77))

  let
    c = newNG8(0, 1, -1, 0, 0, 0, 0, 1)
    c1 = newR2cf(13, 11)
    c2 = newR2cf(22, 7)
  test("[1;5,2] - [3;7]", newNG(c, c1, c2), newR2cf(-151, 77))

  let
    d = newNG8(0, 1, 0, 0, 0, 0, 1, 0)
    d1 = newR2cf(22 * 22, 7 * 7)
    d2 = newR2cf(22,7)
  test("Divide [] by [3;7]", newNG(d, d1, d2))

  let
    na = newNG8(0, 1, 1, 0, 0, 0, 0, 1)
    a1 = newR2cf(2, 7)
    a2 = newR2cf(13, 11)
    aa = newNG(na, a1, a2)
    nb = newNG8(0, 1, -1, 0, 0, 0, 0, 1)
    b3 = newR2cf(2, 7)
    b4 = newR2cf(13, 11)
    bb = newNG(nb, b3, b4)
    nc = newNG8(1, 0, 0, 0, 0, 0, 0, 1)
    desc = "([0;3,2] + [1;5,2]) * ([0;3,2] - [1;5,2])"
  test(desc, newNG(nc, aa, bb), newR2cf(-7797, 5929))
