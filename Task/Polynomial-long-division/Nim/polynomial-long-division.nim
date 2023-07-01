const MinusInfinity = -1

type
  Polynomial = seq[int]
  Term = tuple[coeff, exp: int]

func degree(p: Polynomial): int =
  ## Return the degree of a polynomial.
  ## "p" is supposed to be normalized.
  result = if p.len > 0: p.len - 1 else: MinusInfinity

func normalize(p: var Polynomial) =
  ## Normalize a polynomial, removing useless zeroes.
  while p[^1] == 0: discard p.pop()

func `shr`(p: Polynomial; n: int): Polynomial =
  ## Shift a polynomial of "n" positions to the right.
  result.setLen(p.len + n)
  result[n..^1] = p

func `*=`(p: var Polynomial; n: int) =
  ## Multiply in place a polynomial by an integer.
  for item in p.mitems: item *= n
  p.normalize()

func `-=`(a: var Polynomial; b: Polynomial) =
  ## Substract in place a polynomial from another polynomial.
  for i, val in b: a[i] -= val
  a.normalize()

func longdiv(a, b: Polynomial): tuple[q, r: Polynomial] =
  ## Compute the long division of a polynomial by another.
  ## Return the quotient and the remainder as polynomials.
  result.r = a
  if b.degree < 0: raise newException(DivByZeroDefect, "divisor cannot be zero.")
  result.q.setLen(a.len)
  while (let k = result.r.degree - b.degree; k >= 0):
    var d = b shr k
    result.q[k] = result.r[^1] div d[^1]
    d *= result.q[k]
    result.r -= d
  result.q.normalize()

const Superscripts: array['0'..'9', string] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]

func superscript(n: Natural): string =
  ## Return the Unicode string to use to represent an exponent.
  if n == 1:
    return ""
  for d in $n:
    result.add(Superscripts[d])

func `$`(term: Term): string =
  ## Return the string representation of a term.
  if term.coeff == 0: "0"
  elif term.exp == 0: $term.coeff
  else:
    let base = 'x' & superscript(term.exp)
    if term.coeff == 1: base
    elif term.coeff == -1: '-' & base
    else: $term.coeff & base

func `$`(poly: Polynomial): string =
  ## return the string representation of a polynomial.
  for idx in countdown(poly.high, 0):
    let coeff = poly[idx]
    var term: Term = (coeff: coeff, exp: idx)
    if result.len == 0:
      result.add $term
    else:
      if coeff > 0:
        result.add '+'
        result.add $term
      elif coeff < 0:
        term.coeff = -term.coeff
        result.add '-'
        result.add $term


const
  N = @[-42, 0, -12, 1]
  D = @[-3, 1]

let (q, r) = longdiv(N, D)
echo "N = ", N
echo "D = ", D
echo "q = ", q
echo "r = ", r
