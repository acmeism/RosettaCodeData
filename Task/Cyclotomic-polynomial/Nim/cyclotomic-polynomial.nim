import algorithm, math, sequtils, strformat, tables

type

  Term = tuple[coeff: int; exp: Natural]
  Polynomial = seq[Term]

  # Table used to represent the list of factors of a number.
  # If, for a number "n", "k" is present in the table "f" of its factors,
  # "f[k]" contains the exponent of "k" in the prime factor decomposition.
  Factors = Table[int, int]


####################################################################################################
# Miscellaneous.

## Parity tests.
template isOdd(n: int): bool = (n and 1) != 0
template isEven(n: int): bool = (n and 1) == 0

#---------------------------------------------------------------------------------------------------

proc sort(poly: var Polynomial) {.inline.} =
  ## Sort procedure for the terms of a polynomial (high degree first).
  algorithm.sort(poly, proc(x, y: Term): int = cmp(x.exp, y.exp), Descending)


####################################################################################################
# Superscripts.

const Superscripts: array['0'..'9', string] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]

func superscript(n: Natural): string =
  ## Return the Unicode string to use to represent an exponent.
  if n == 1:
    return ""
  for d in $n:
    result.add(Superscripts[d])


####################################################################################################
# Term operations.

func term(coeff, exp: int): Term =
  ## Create a term.
  if exp < 0:
    raise newException(ValueError, "term exponent cannot be negative")
  (coeff, Natural exp)

#---------------------------------------------------------------------------------------------------

func `*`(a, b: Term): Term =
  ## Multiply two terms.
  (a.coeff * b.coeff, Natural a.exp + b.exp)

#---------------------------------------------------------------------------------------------------

func `+`(a, b: Term): Term =
  ## Add two terms.

  if a.exp != b.exp:
    raise newException(ValueError, "addition of terms with unequal exponents")
  (a.coeff + b.coeff, a.exp)

#---------------------------------------------------------------------------------------------------

func `-`(a: Term): Term =
  ## Return the opposite of a term.
  (-a.coeff, a.exp)

#---------------------------------------------------------------------------------------------------

func `$`(a: Term): string =
  ## Return the string representation of a term.
  if a.coeff == 0: "0"
  elif a.exp == 0: $a.coeff
  elif a.coeff == 1: 'x' & superscript(a.exp)
  elif a.coeff == -1: "-x" & superscript(a.exp)
  else: $a.coeff & 'x' & superscript(a.exp)


####################################################################################################
# Polynomial.

func polynomial(terms: varargs[Term]): Polynomial =
  ## Create a polynomial described by its terms.
  for t in terms:
    if t.coeff != 0:
      result.add(t)
  if result.len == 0:
    return @[term(0, 0)]
  sort(result)

#---------------------------------------------------------------------------------------------------

func hasCoeffAbs(poly: Polynomial; coeff: int): bool =
  ## Return true if the polynomial contains a given coefficient.
  for t in poly:
    if abs(t.coeff) == coeff:
      return true

#---------------------------------------------------------------------------------------------------

func leadingCoeff(poly: Polynomial): int {.inline.} =
  ## Return the coefficient of the term with the highest degree.
  poly[0].coeff

#---------------------------------------------------------------------------------------------------

func degree(poly: Polynomial): int {.inline.} =
  ## Return the degree of the polynomial.
  if poly.len == 0: -1
  else: poly[0].exp

#---------------------------------------------------------------------------------------------------

func `+`(poly: Polynomial; someTerm: Term): Polynomial =
  ## Add a term to a polynomial.

  var added = false
  for currTerm in poly:
    if currterm.exp == someTerm.exp:
      added = true
      if currTerm.coeff + someTerm.coeff != 0:
        result.add(currTerm + someTerm)
    else:
      result.add(currTerm)

  if not added:
    result.add(someTerm)

#---------------------------------------------------------------------------------------------------

func `+`(a, b: Polynomial): Polynomial =
  ## Add two polynomials.

  var aIndex = a.high
  var bIndex = b.high

  while aIndex >= 0 or bIndex >= 0:
    if aIndex < 0:
      result &= b[bIndex]
      dec bIndex
    elif bIndex < 0:
      result &= a[aIndex]
      dec aIndex
    else:
      let t1 = a[aIndex]
      let t2 = b[bIndex]
      if t1.exp == t2.exp:
        let t3 = t1 + t2
        if t3.coeff != 0:
          result.add(t3)
        dec aIndex
        dec bIndex
      elif t1.exp < t2.exp:
        result.add(t1)
        dec aIndex
      else:
        result.add(t2)
        dec bIndex

  sort(result)

#---------------------------------------------------------------------------------------------------

func `*`(poly: Polynomial; someTerm: Term): Polynomial =
  ## Multiply a polynomial by a term.
  for currTerm in poly:
    result.add(currTerm * someTerm)

#---------------------------------------------------------------------------------------------------

func `/`(a, b: Polynomial): Polynomial =
  ## Divide a polynomial by another polynomial.

  var a = a
  let lcb = b.leadingCoeff
  let db = b.degree
  while a.degree >= b.degree:
    let lca = a.leadingCoeff
    let s = lca div lcb
    let t = term(s, a.degree - db)
    result = result + t
    a = a + b * -t

#---------------------------------------------------------------------------------------------------

func `$`(poly: Polynomial): string =
  ## Return the string representation of a polynomial.

  for t in poly:
    if result.len == 0:
      result.add($t)
    else:
      if t.coeff > 0:
        result.add('+')
        result.add($t)
      else:
        result.add('-')
        result.add($(-t))


####################################################################################################
# Cyclotomic polynomial.

var

  # Cache of list of factors.
  factorCache: Table[int, Factors] = {2: {2: 1}.toTable}.toTable

  # Cache of cyclotomic polynomials. Initialized with 1 -> x - 1.
  polyCache: Table[int, Polynomial] = {1: polynomial(term(1, 1), term(-1, 0))}.toTable

#---------------------------------------------------------------------------------------------------

proc getFactors(n: int): Factors =
  ## Return the list of factors of a number.

  if n in factorCache:
    return factorCache[n]

  if n.isEven:
    result = getFactors(n div 2)
    result[2] = result.getOrDefault(2) + 1
    factorCache[n] = result
    return

  var i = 3
  while i * i <= n:
    if n mod i == 0:
      result = getFactors( n div i)
      result[i] = result.getOrDefault(i) + 1
      factorCache[n] = result
      return
    inc i, 2

  result[n] = 1
  factorCache[n] = result

#---------------------------------------------------------------------------------------------------

proc cycloPoly(n: int): Polynomial =
  ## Find the nth cyclotomic polynomial.

  if n in polyCache:
    return polyCache[n]

  let factors = getFactors(n)

  if n in factors:
    # n is prime.
    for i in countdown(n - 1, 0):       # Add the terms by decreasing degrees.
      result.add(term(1, i))

  elif factors.len == 2 and factors.getOrDefault(2) == 1 and factors.getOrDefault(n div 2) == 1:
    # n = 2 x prime.
    let prime = n div 2
    var coeff = -1
    for i in countdown(prime - 1, 0):   # Add the terms by decreasing degrees.
      coeff *= -1
      result.add(term(coeff, i))

  elif factors.len == 1 and 2 in factors:
    # n = 2 ^ h.
    let h = factors[2]
    result.add([term(1, 1 shl (h - 1)), term(1, 0)])

  elif factors.len == 1 and n notin factors:
    # n = prime ^ k.
    var p, k = 0
    for prime, v in factors.pairs:
      if prime > p:
        p = prime
        k = v
    for i in countdown(p - 1, 0):       # Add the terms by decreasing degrees.
      result.add(term(1, i * p^(k-1)))

  elif factors.len == 2 and 2 in factors:
    # n = 2 ^ h x prime ^ k.
    var p, k = 0
    for prime, v in factors.pairs:
      if prime != 2 and prime > p:
        p = prime
        k = v
    var coeff = -1
    let twoExp = 1 shl (factors[2] - 1)
    for i in countdown(p - 1, 0):       # Add the terms by decreasing degrees.
      coeff *= -1
      result.add(term(coeff, i * twoExp * p^(k-1)))

  elif 2 in factors and isOdd(n div 2) and n div 2 > 1:
    # CP(2m)[x] = CP(-m)[x], n odd integer > 1.
    let cycloDiv2 = cycloPoly(n div 2)
    for t in cycloDiv2:
      result.add(if t.exp.isEven: t else: -t)

  else:
    # Let p, q be primes such that p does not divide n, and q divides n.
    # Then CP(np)[x] = CP(n)[x^p] / CP(n)[x].
    var m = 1
    var cyclo = cycloPoly(m)
    let primes = sorted(toSeq(factors.keys))
    for prime in primes:
      # Compute CP(m)[x^p].
      var terms: Polynomial
      for t in cyclo:
        terms.add(term(t.coeff, t.exp * prime))
      cyclo = terms / cyclo
      m *= prime
    # Now, m is the largest square free divisor of n.
    let s = n div m
    # Compute CP(n)[x] = CP(m)[x^s].
    for t in cyclo:
      result.add(term(t.coeff, t.exp * s))

  polyCache[n] = result


#———————————————————————————————————————————————————————————————————————————————————————————————————

echo "Cyclotomic polynomials for n ⩽ 30:"
for i in 1..30:
  echo &"Φ{'(' & $i & ')':4} = {cycloPoly(i)}"

echo ""
echo "Smallest cyclotomic polynomial with n or -n as a coefficient:"
var n = 0
for i in 1..10:
  while true:
    inc n
    if cycloPoly(n).hasCoeffAbs(i):
      echo &"Φ{'(' & $n & ')':7} has coefficient with magnitude = {i}"
      dec n
      break
