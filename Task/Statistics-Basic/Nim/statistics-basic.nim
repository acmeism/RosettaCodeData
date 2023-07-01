import random, sequtils, stats, strutils, strformat

proc drawHistogram(ns: seq[float]) =
  var h = newSeq[int](11)
  for n in ns:
    let pos = (n * 10).toInt
    inc h[pos]

  const maxWidth = 50
  let mx = max(h)
  echo ""
  for n, count in h:
    echo n.toFloat / 10, ": ", repeat('+', int(count / mx * maxWidth))
  echo ""

randomize()

# First part: compute directly from a sequence of values.
echo "For 100 numbers:"
let ns = newSeqWith(100, rand(1.0))
echo &"μ = {ns.mean:.12f}   σ = {ns.standardDeviation:.12f}"
ns.drawHistogram()

# Second part: compute incrementally using "RunningStat".
for count in [1_000, 10_000, 100_000, 1_000_000]:
  echo &"For {count} numbers:"
  var rs: RunningStat
  for _ in 1..count:
    let n = rand(1.0)
    rs.push(n)
  echo &"μ = {rs.mean:.12f}   σ = {rs.standardDeviation:.12f}"
  echo()
