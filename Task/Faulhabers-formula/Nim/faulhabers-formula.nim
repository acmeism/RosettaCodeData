import math, rationals

type
  Fraction = Rational[int]
  FaulhaberSequence = seq[Fraction]

const
  Zero = 0 // 1
  One = 1 // 1
  MinusOne = -1 // 1
  Powers = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]

#---------------------------------------------------------------------------------------------------

func bernoulli(n: Natural): Fraction =
  ## Return nth Bernoulli coefficient.

  var a = newSeq[Fraction](n + 1)
  for m in 0..n:
    a[m] = 1 // (m + 1)
    for k in countdown(m, 1):
      a[k - 1] = (a[k - 1] - a[k]) * k
  result = if n != 1: a[0] else: -a[0]

#---------------------------------------------------------------------------------------------------

func faulhaber(n: Natural): FaulhaberSequence =
  ## Return nth Faulhaber sequence.

  var a = 1 // (n + 1)
  var sign = -1
  for k in 0..n:
    sign = -sign
    result.add(a * sign * binom(n + 1, k) * bernoulli(k))

#---------------------------------------------------------------------------------------------------

func npower(k: Natural): string =
  ## Return the string representing "n" at power "k".

  if k == 0: return ""
  if k == 1: return "n"
  var k = k
  result = "n"
  while k != 0:
    result.insert(Powers[k mod 10], 1)
    k = k div 10

#---------------------------------------------------------------------------------------------------

func `$`(fs: FaulhaberSequence): string =
  ## Return the string representing a Faulhaber sequence.

  for i, coeff in fs:

    # Process coefficient.
    if coeff.num == 0: continue
    if i == 0:
      if coeff == MinusOne: result.add(" - ")
      elif coeff != One: result.add($coeff)
    else:
      if coeff == One: result.add(" + ")
      elif coeff == MinusOne: result.add(" - ")
      elif coeff > Zero: result.add(" + " & $coeff)
      else: result.add(" - " & $(-coeff))

    # Process power of "n".
    let pwr = fs.len - i
    result.add(npower(pwr))

#———————————————————————————————————————————————————————————————————————————————————————————————————

for n in 0..9:
  echo n, ": ", faulhaber(n)
