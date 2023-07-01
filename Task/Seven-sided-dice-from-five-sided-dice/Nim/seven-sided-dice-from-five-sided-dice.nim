import random, tables


proc dice5(): int = rand(1..5)


proc dice7(): int =
  while true:
    let val = 5 * dice5() + dice5() - 6
    if val < 21:
      return val div 3 + 1


proc checkDist(f: proc(): int; repeat: Positive; tolerance: float) =

  var counts: CountTable[int]
  for _ in 1..repeat:
    counts.inc f()

  let expected = (repeat / counts.len).toInt    # Rounded to nearest.
  let allowedDelta = (expected.toFloat * tolerance / 100).toInt
  var maxDelta = 0
  for val, count in counts.pairs:
    let d = abs(count - expected)
    if d > maxDelta: maxDelta = d

  let status = if maxDelta <= allowedDelta: "passed" else: "failed"
  echo "Checking ", repeat, " values with a tolerance of ", tolerance, "%."
  echo "Random generator ", status, " the uniformity test."
  echo "Max delta encountered = ", maxDelta, "   Allowed delta = ", allowedDelta


when isMainModule:
  import random
  randomize()
  checkDist(dice7, 1_000_000, 0.5)
