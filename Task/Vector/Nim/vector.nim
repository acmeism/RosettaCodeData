import strformat

type Vec2[T: SomeNumber] = tuple[x, y: T]

proc initVec2[T](x, y: T): Vec2[T] = (x, y)

func`+`[T](a, b: Vec2[T]): Vec2[T] = (a.x + b.x, a.y + b.y)

func `-`[T](a, b: Vec2[T]): Vec2[T] = (a.x - b.x, a.y - b.y)

func `*`[T](a: Vec2[T]; m: T): Vec2[T] = (a.x * m, a.y * m)

func `/`[T](a: Vec2[T]; d: T): Vec2[T] =
  if d == 0:
    raise newException(DivByZeroDefect, "division of vector by 0")
  when T is SomeInteger:
    (a.x div d, a.y div d)
  else:
    (a.x / d, a.y / d)

func `$`[T](a: Vec2[T]): string =
  &"({a.x}, {a.y})"

# Three ways to initialize a vector.
let v1 = initVec2(2, 3)
let v2: Vec2[int] = (-1, 2)
let v3 = (x: 4, y: -2)

echo &"{v1} + {v2} = {v1 + v2}"
echo &"{v3} - {v2} = {v3 - v2}"

# Float vectors.
let v4 = initVec2(2.0, 3.0)
let v5 = (x: 3.0, y: 2.0)

echo &"{v4} * 2 = {v4 * 2}"
echo &"{v3} / 2 = {v3 / 2}"   # Int division.
echo &"{v5} / 2 = {v5 / 2}"   # Float division.
