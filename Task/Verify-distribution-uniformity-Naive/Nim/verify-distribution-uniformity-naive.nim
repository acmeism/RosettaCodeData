import tables


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
  proc rand5(): int = rand(1..5)
  checkDist(rand5, 1_000_000, 0.5)
