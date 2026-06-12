import std/strformat

type RE = ref object of RootObj

method `==`(self, other: RE): bool {.base.} =
  raise newException(CatchableError, "Method without implementation override")

method `$`(self: RE): string {.base.} =
  raise newException(CatchableError, "Method without implementation override")


type Empty = ref object of RE

method `==`(self: Empty; other: RE): bool =
  other of Empty

method `$`(self: Empty): string = "0"

let empty = Empty()


type Epsilon = ref object of RE

method `==`(self: Epsilon; other: RE): bool =
  other of Epsilon

method `$`(self: Epsilon): string = "1"

let epsilon = Epsilon()


type Car = ref object of RE
  c: char

proc initCar(c: char): Car = Car(c: c)

method `==`(self: Car; other: RE): bool =
  other of Car and self.c == Car(other).c

method `$`(self: Car): string = $self.c


type Union = ref object of RE
  e, f: RE

proc initUnion(e, f: RE): Union = Union(e: e, f: f)

method `==`(self: Union; other: RE): bool =
  if not (other of Union): return false
  result = self.e == Union(other).e and self.f == Union(other).f

method `$`(self: Union): string = &"{self.e}+{self.f}"


type Concat = ref object of RE
  e, f: RE

proc initConcat(e, f: RE): Concat = Concat(e: e, f: f)

method `==`(self: Concat; other: RE): bool =
  if not (other of Concat): return false
  result = self.e == Concat(other).e and self.f == Concat(other).f

method `$`(self: Concat): string = &"({self.e})({self.f})"


type Star = ref object of RE
  e: RE

proc initStar(e: RE): Star = Star(e: e)

method `==`(self: Star; other: RE): bool =
  if not (other of Star): return false
  result = self.e == Star(other).e

method `$`(self: Star): string = &"({self.e})*"


proc simpleRE(e: RE): RE =

  proc simple(e: RE): RE =
    if e of Union:
      let ee = simple(Union(e).e)
      let ef = simple(Union(e).f)
      result = if ee == ef: ee
               elif ee of Union: simple(initUnion(Union(ee).e, initUnion(Union(ee).f, ef)))
               elif ee of Empty: ef
               elif ef of Empty: ee
               else: initUnion(ee, ef)
    elif e of Concat:
      let ee = simple(Concat(e).e)
      let ef = simple(Concat(e).f)
      result = if ee of Epsilon: ef
               elif ef of Epsilon: ee
               elif ee of Empty or ef of Empty: empty
               elif ee of Concat: simple(initConcat(Concat(ee).e, initConcat(Concat(ee).f, ef)))
               else: initConcat(ee, ef)
    elif e of Star:
      let ee = simple(Star(e).e)
      result = if ee of Empty or ee of Epsilon: epsilon
               else: initStar(ee)
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
