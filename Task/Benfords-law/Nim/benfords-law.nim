import math
import strformat

type

  # Non zero digit range.
  Digit = range[1..9]

  # Count array used to compute a distribution.
  Count = array[Digit, Natural]

  # Array to store frequencies.
  Distribution = array[Digit, float]


####################################################################################################
# Fibonacci numbers generation.

import bignum

proc fib(count: int): seq[Int] =
  ## Build a sequence of "count auccessive Finonacci numbers.
  result.setLen(count)
  result[0..1] = @[newInt(1), newInt(1)]
  for i in 2..<count:
    result[i] = result[i-1] + result[i-2]


####################################################################################################
# Benford distribution.

proc benfordDistrib(): Distribution =
  ## Compute Benford distribution.

  for d in 1..9:
    result[d] = log10(1 + 1 / d)

const BenfordDist = benfordDistrib()

#---------------------------------------------------------------------------------------------------

template firstDigit(n: Int): Digit =
  # Return the first (non null) digit of "n".
  ord(($n)[0]) - ord('0')

#---------------------------------------------------------------------------------------------------

proc actualDistrib(s: openArray[Int]): Distribution =
  ## Compute actual distribution of first digit.
  ## Null values are ignored.

  var counts: Count
  for val in s:
    if not val.isZero():
      inc counts[val.firstDigit()]

  let total = sum(counts)
  for d in 1..9:
    result[d] = counts[d] / total

#---------------------------------------------------------------------------------------------------

proc display(distrib: Distribution) =
  ## Display an actual distribution versus the Benford reference distribution.

  echo "d   actual   expected"
  echo "---------------------"
  for d in 1..9:
    echo fmt"{d}   {distrib[d]:6.4f}    {BenfordDist[d]:6.4f}"


#———————————————————————————————————————————————————————————————————————————————————————————————————

let fibSeq = fib(1000)
let distrib = actualDistrib(fibSeq)
echo "Fibonacci numbers first digit distribution:\n"
distrib.display()
