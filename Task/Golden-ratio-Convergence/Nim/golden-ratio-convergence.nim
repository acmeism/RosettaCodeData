import std/strutils

iterator goldenRatio(): (int, float) =
  var phi = 1.0
  var idx = 0
  while true:
    yield (idx, phi)
    phi = 1 + 1 / phi
    inc idx

const Eps = 1e-5
const Phi = 1.6180339887498948482045868343656381177203091798057628621354486
var prev = 0.0
for (i, phi) in goldenRatio():
  if abs(phi - prev) <= Eps:
    echo "Final value of φ: ", phi
    echo "Number of iterations: ", i
    echo "Approximative error: ", formatFloat(phi - Phi, ffDecimal)
    break
  prev = phi
