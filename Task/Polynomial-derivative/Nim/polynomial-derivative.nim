import std/sequtils

type
  Polynomial[T] = object
    coeffs: seq[T]
  Term = tuple[coeff, exp: int]

template `[]`[T](poly: Polynomial[T]; idx: Natural): T =
  poly.coeffs[idx]

template `[]=`[T](poly: var Polynomial; idx: Natural; val: T) =
  poly.coeffs[idx] = val

template degree(poly: Polynomial): int =
  poly.coeffs.high

func newPolynomial[T](coeffs: openArray[T]): Polynomial[T] =
  ## Create a polynomial from a list of coefficients.
  result.coeffs = coeffs.toSeq

func newPolynomial[T](degree: Natural = 0): Polynomial[T] =
  ## Create a polynomial with given degree.
  ## Coefficients are all zeroes.
  result.coeffs = newSeq[T](degree + 1)

const Superscripts: array['0'..'9', string] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]

func superscript(n: Natural): string =
  ## Return the Unicode string to use to represent an exponent.
  if n == 1:
    return ""
  for d in $n:
    result.add Superscripts[d]

func `$`(term: Term): string =
  ## Return the string representation of a term.
  if term.coeff == 0: "0"
  elif term.exp == 0: $term.coeff
  else:
    let base = 'x' & superscript(term.exp)
    if term.coeff == 1: base
    elif term.coeff == -1: '-' & base
    else: $term.coeff & base

func `$`[T](poly: Polynomial[T]): string =
  ## Return the string representation of a polynomial.
  for idx in countdown(poly.degree, 0):
    let coeff = poly[idx]
    var term: Term = (coeff: coeff, exp: idx)
    if result.len == 0:
      result.add $term
    elif coeff > 0:
      result.add '+'
      result.add $term
    elif coeff < 0:
      term.coeff = -term.coeff
      result.add '-'
      result.add $term

func derivative[T](poly: Polynomial[T]): Polynomial[T] =
  ## Return the derivative of a polynomial.
  if poly.degree == 0: return newPolynomial[T]()
  result = newPolynomial[T](poly.degree - 1)
  for degree in 1..poly.degree:
    result[degree - 1] = degree * poly[degree]

for coeffs in @[@[5], @[4, -3], @[-1, 6, 5], @[-4, 3, -2, 1], @[1, 1, 0, -1, -1]]:
  let poly = newPolynomial(coeffs)
  echo "Polynomial: ", poly
  echo "Derivative: ", poly.derivative
  echo()
