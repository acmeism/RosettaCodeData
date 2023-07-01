import math, random, sequtils, stats, strformat, strutils

proc drawHistogram(ns: seq[float]) =

  # Distribute values in bins.
  const NBins = 50
  var minval = min(ns)
  var maxval = max(ns)
  var h = newSeq[int](NBins + 1)
  for n in ns:
    let pos = ((n - minval) * NBins / (maxval - minval)).toInt
    inc h[pos]

  # Eliminate extremes values.
  const MaxWidth = 50
  let mx = max(h)
  var first = 0
  while (h[first] / mx * MaxWidth).toInt == 0: inc first
  var last = h.high
  while (h[last] / mx * MaxWidth).toInt == 0: dec last

  # Draw the histogram.
  echo ""
  for n in first..last:
    echo repeat('+', (h[n] / mx * MaxWidth).toInt)
  echo ""


const N = 100_000

randomize()

let u1, u2 = newSeqWith(N, rand(1.0))

var z = newSeq[float](N)
for i in 0..<N:
  z[i] = sqrt(-2 * ln(u1[i])) * cos(2 * PI * u2[i])

echo &"μ = {z.mean:.12f}   σ = {z.standardDeviation:.12f}"
z.drawHistogram()
