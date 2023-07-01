import bignum
import strformat

const Lim = 60

#---------------------------------------------------------------------------------------------------

proc bernoulli(n: Natural): Rat =
  ## Compute a Bernoulli number using Akiyama–Tanigawa algorithm.

  var a = newSeq[Rat](n + 1)
  for m in 0..n:
    a[m] = newRat(1, m + 1)
    for j in countdown(m, 1):
      a[j-1] = j * (a[j] - a[j-1])
  result = a[0]


#———————————————————————————————————————————————————————————————————————————————————————————————————

type Info = tuple
  n: int        # Number index in Bernoulli sequence.
  val: Rat      # Bernoulli number.

var values: seq[Info]   # List of values as Info tuples.
var maxLen = -1         # Maximum length.

# First step: compute the values and prepare for display.
for n in 0..Lim:
  # Compute value.
  if n != 1 and (n and 1) == 1: continue    # Ignore odd "n" except 1.
  let b = bernoulli(n)
  # Check numerator length.
  let len = ($b.num).len
  if len > maxLen: maxLen = len
  # Store information for next step.
  values.add((n, b))

# Second step: display the values with '/' aligned.
for (n, b) in values:
  let s = fmt"{($b.num).alignString(maxLen, '>')} / {b.denom}"
  echo fmt"{n:2}: {s}"
