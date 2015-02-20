import math // import for sqrt() function

amean: func (x: Double, y: Double) -> Double {
  (x + y) / 2.
}
gmean: func (x: Double, y: Double) -> Double {
  sqrt(x * y)
}
agm: func (a: Double, g: Double) -> Double {
  while ((a - g) abs() > pow(10, -12)) {
    (a1, g1) := (amean(a, g), gmean(a, g))
    (a, g) = (a1, g1)
  }
  a
}

main: func {
  "%.16f" printfln(agm(1., sqrt(0.5)))
}
