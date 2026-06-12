import std/strformat

type

  ReKind = enum reEmpty, reEpsilon, reCar, reUnion, reConcat, reStar

  RE = ref object
    case kind: ReKind
    of reEmpty, reEpsilon:
      nil
    of reCar:
      c: char
    of reUnion, reConcat:
      e, f: RE
    of reStar:
      s: RE


proc `==`(r1, r2: RE): bool =
  ## Compare two regular expressions.
  if r1.kind != r2.kind: return false
  result = case r1.kind
            of reEmpty, reEpsilon: true
            of reCar: r1.c == r2.c
            of reUnion, reConcat: r1.e == r2.e and r1.f == r2.f
            of reStar: r1.s == r2.s


proc `$`(r: RE): string =
  ## String representation of a regular expression.
  result = case r.kind
           of reEmpty: "0"
           of reEpsilon: "1"
           of reCar: $r.c
           of reUnion: &"{r.e}+{r.f}"
           of reConcat: &"({r.e})({r.f})"
           of reStar: &"({r.s})*"


# Templates to create regular expressions.
template initEmpty(): RE = RE(kind: reEmpty)
template initEpsilon(): RE = RE(kind: reEpsilon)
template initCar(ch: char): RE = RE(kind: reCar, c: ch)
template initUnion(r1, r2: RE): RE = RE(kind: reUnion, e: r1, f: r2)
template initConcat(r1, r2: RE): RE = RE(kind: reConcat, e: r1, f: r2)
template initStar(r: RE): RE = RE(kind: reStar, s: r)


# Empty and Epsilon objects.
let empty = initEmpty()
let epsilon = initEpsilon()


proc simpleRE(e: RE): RE =

  proc simple(e: RE): RE =
    case e.kind
    of reUnion:
      let ee = simple(e.e)
      let ef = simple(e.f)
      result = if ee == ef: ee
               elif ee.kind == reUnion: simple(initUnion(ee.e, initUnion(ee.f, ef)))
               elif ee.kind == reEmpty: ef
               elif ef.kind == reEmpty: ee
               else: initUnion(ee, ef)
    of reConcat:
      let ee = simple(e.e)
      let ef = simple(e.f)
      result = if ee.kind == reEpsilon: ef
               elif ef.kind == reEpsilon: ee
               elif ee.kind == reEmpty or ef.kind == reEmpty: empty
               elif ee.kind == reConcat: simple(initConcat(ee.e, initConcat(ee.f, ef)))
               else: initConcat(ee, ef)
    of reStar:
      let es = simple(e.s)
      result = if es.kind == reEmpty or es.kind == reEpsilon: epsilon
               else: initStar(es)
    else:
      result = e

  result = e
  while true:
    let next = simple(result)
    if next == result: break
    result = next


type
  Vector[N: static Positive] = array[N, RE]
  Matrix[N: static Positive] = array[N, array[N, RE]]


proc brzozowski(a: Matrix; b: Vector): RE =
  assert a.N == b.N
  var a = a
  var b = b
  for n in countdown(a.high, 0):
    let ann = a[n][n]
    b[n] = initConcat(initStar(ann), b[n])
    for j in 0..<n:
      a[n][j] = initConcat(initStar(ann), a[n][j])
    for i in 0..<n:
      b[i] = initUnion(b[i], initConcat(a[i][n], b[n]))
      for j in 0..<n:
        a[i][j] = initUnion(a[i][j], initConcat(a[i][n], a[n][j]))
    for i in 0..<n:
      a[i][n] = empty
  result = b[0]


when isMainModule:

  let a: Matrix[3] = [[empty, initCar('a'), initCar('b')],
                      [initCar('b'), empty, initCar('a')],
                      [initCar('a'), initcar('b'), empty]]

  let b: Vector[3] = [epsilon, empty, empty]

  let re = brzozowski(a, b)
  echo "Original:\n", re
  echo()
  echo "Simplified:\n", simpleRE(re)
