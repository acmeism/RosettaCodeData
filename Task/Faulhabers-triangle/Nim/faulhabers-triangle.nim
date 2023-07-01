import algorithm, math, strutils
import bignum

type FaulhaberSequence = seq[Rat]

#---------------------------------------------------------------------------------------------------

func bernoulli(n: Natural): Rat =
  ## Return nth Bernoulli coefficient.

  var a = newSeq[Rat](n + 1)
  for m in 0..n:
    a[m] = newRat(1, m + 1)
    for k in countdown(m, 1):
      a[k - 1] = (a[k - 1] - a[k]) * k
  result = if n != 1: a[0] else: -a[0]

#---------------------------------------------------------------------------------------------------

func faulhaber(n: Natural): FaulhaberSequence =
  ## Return nth Faulhaber sequence (high degree first).

  var a = newRat(1, n + 1)
  var sign = -1
  for k in 0..n:
    sign = -sign
    result.add(a * sign * binom(n + 1, k) * bernoulli(k))

#---------------------------------------------------------------------------------------------------

proc display(fs: FaulhaberSequence) =
  ## Return the string representing a Faulhaber sequence.

  var str = ""
  for i, coeff in reversed(fs):
    str.addSep(" ", 0)
    str.add(($coeff).align(6))
  echo str

#---------------------------------------------------------------------------------------------------

func evaluate(fs: FaulhaberSequence; n: int): Rat =
  ## Evaluate the polynomial associated to a sequence for value "n".

  result = newRat(0)
  for coeff in fs:
    result = result * n + coeff
  result *= n

#———————————————————————————————————————————————————————————————————————————————————————————————————

for n in 0..9:
  display(faulhaber(n))

echo ""
let fs18 = faulhaber(17)  # 18th row.
echo fs18.evaluate(1000)
