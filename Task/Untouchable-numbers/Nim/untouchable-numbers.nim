import math, strutils

const
  Lim1 = 100_000    # Limit for untouchable numbers.
  Lim2 = 14 * Lim1  # Limit for computation of sum of divisors.

proc sumdiv(n: uint): uint =
  ## Return the sum of the strict divisors of "n".
  result = 1
  let r = sqrt(n.float).uint
  let k = if (n and 1) == 0: 1u else: 2u
  for d in countup(k + 1, r, k):
    if n mod d == 0:
      result += d
      let q = n div d
      if q != d: result += q

var
  isSumDiv: array[1..Lim2, bool]
  isPrime: array[1..Lim1, bool]

# Fill both sieves in a single pass.
for n in 1u..Lim2:
  let s = sumdiv(n)
  if s <= Lim2:
    isSumDiv[s] = true
    if s == 1 and n <= Lim1:
      isPrime[n] = true
isPrime[1] = false

# Build list of untouchable numbers.
var list = @[2, 5]
for n in countup(6, Lim1, 2):
  if not (isSumDiv[n] or isPrime[n - 1] or isPrime[n - 3]):
    list.add n

echo "Untouchable numbers ≤ 2000:"
var count, lcount = 0
for n in list:
  if n <= 2000:
    stdout.write ($n).align(5)
    inc count
    inc lcount
    if lcount == 20:
      echo()
      lcount = 0
  else:
    if lcount > 0: echo()
    break

const CountMessage = "There are $1 untouchable numbers ≤ $2."
echo CountMessage.format(count, 2000), '\n'

count = 0
var lim = 10
for n in list:
  if n > lim:
    echo CountMessage.format(count, lim)
    lim *= 10
  inc count
if lim == Lim1:
  # Emit last message.
  echo CountMessage.format(count, lim)
