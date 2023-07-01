import strformat
import bignum

type Metal {.pure.} = enum platinum, golden, silver, bronze, copper, nickel, aluminium, iron, tin, lead

iterator sequence(b: int): Int =
  ## Yield the successive terms if a “Lucas” sequence.
  ## The first two terms are ignored.
  var x, y = newInt(1)
  while true:
    x += b * y
    swap x, y
    yield y


template plural(n: int): string =
  if n >= 2: "s" else: ""


proc computeRatio(b: Natural; digits: Positive) =
  ## Compute the ratio for the given "n" with the required number of digits.

  let M = 10^culong(digits)

  var niter = 0           # Number of iterations.
  var prevN = newInt(1)   # Previous value of "n".
  var ratio = M           # Current value of ratio.

  for n in sequence(b):
    inc niter
    let nextRatio = n * M div prevN
    if nextRatio == ratio: break
    prevN = n.clone
    ratio = nextRatio

  var str = $ratio
  str.insert(".", 1)
  echo &"Value to {digits} decimal places after {niter} iteration{plural(niter)}: ", str


when isMainModule:

  for b in 0..9:
    echo &"“Lucas” sequence for {Metal(b)} ratio where b = {b}:"
    stdout.write "First 15 elements: 1 1"
    var count = 2
    for n in sequence(b):
      stdout.write ' ', n
      inc count
      if count == 15: break
    echo ""
    computeRatio(b, 32)
    echo ""

  echo "Golden ratio where b = 1:"
  computeRatio(1, 256)
