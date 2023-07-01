import math, complex, strformat

const Epsilon = 1e-15

type

  SolKind = enum solDouble, solFloat, solComplex

  Roots = object
    case kind: SolKind
    of solDouble:
      fvalue: float
    of solFloat:
      fvalues: (float, float)
    of solComplex:
      cvalues: (Complex64, Complex64)


func quadRoots(a, b, c: float): Roots =
  if a == 0:
    raise newException(ValueError, "first coefficient cannot be null.")
  let den = a * 2
  let Δ = b * b - a * c * 4
  if abs(Δ) < Epsilon:
    result = Roots(kind: solDouble, fvalue: -b / den)
  elif Δ < 0:
    let r = -b / den
    let i = sqrt(-Δ) / den
    result = Roots(kind: solComplex, cvalues: (complex64(r, i), complex64(r, -i)))
  else:
    let r = (if b < 0: -b + sqrt(Δ) else: -b - sqrt(Δ)) / den
    result = Roots(kind: solFloat, fvalues: (r, c / (a * r)))


func `$`(r: Roots): string =
  case r.kind
  of solDouble:
    result = $r.fvalue
  of solFloat:
    result = &"{r.fvalues[0]}, {r.fvalues[1]}"
  of solComplex:
    result = &"{r.cvalues[0].re} + {r.cvalues[0].im}i, {r.cvalues[1].re} + {r.cvalues[1].im}i"


when isMainModule:

  const Equations = [(1.0, -2.0, 1.0),
                    (10.0, 1.0, 1.0),
                    (1.0, -10.0, 1.0),
                    (1.0, -1000.0, 1.0),
                    (1.0, -1e9, 1.0)]

  for (a, b, c) in Equations:
    echo &"Equation: {a=}, {b=}, {c=}"
    let roots = quadRoots(a, b, c)
    let plural = if roots.kind == solDouble: "" else: "s"
    echo &"    root{plural}: {roots}"
