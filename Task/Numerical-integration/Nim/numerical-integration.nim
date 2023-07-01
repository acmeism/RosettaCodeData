type Function = proc(x: float): float
type Rule = proc(f: Function; x, h: float): float

proc leftRect(f: Function; x, h: float): float =
  f(x)

proc midRect(f: Function; x, h: float): float =
  f(x + h/2.0)

proc rightRect(f: Function; x, h: float): float =
  f(x + h)

proc trapezium(f: Function; x, h: float): float =
  (f(x) + f(x+h)) / 2.0

proc simpson(f: Function, x, h: float): float =
  (f(x) + 4.0*f(x+h/2.0) + f(x+h)) / 6.0

proc cube(x: float): float =
  x * x * x

proc reciprocal(x: float): float =
  1.0 / x

proc identity(x: float): float =
  x

proc integrate(f: Function; a, b: float; steps: int; meth: Rule): float =
  let h = (b-a) / float(steps)
  for i in 0 ..< steps:
    result += meth(f, a+float(i)*h, h)
  result = h * result

for fName, a, b, steps, fun in items(
   [("cube", 0, 1, 100, cube),
    ("reciprocal", 1, 100, 1000, reciprocal),
    ("identity", 0, 5000, 5_000_000, identity),
    ("identity", 0, 6000, 6_000_000, identity)]):

  for rName, rule in items({"leftRect": leftRect, "midRect": midRect,
      "rightRect": rightRect, "trapezium": trapezium, "simpson": simpson}):

    echo fName, " integrated using ", rName
    echo "  from ", a, " to ", b, " (", steps, " steps) = ",
      integrate(fun, float(a), float(b), steps, rule)
