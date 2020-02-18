import strformat
import math

const N = 32
const N2 = N * (N - 1) div 2
const STEP = 0.05

var xval = newSeq[float](N)
var tsin = newSeq[float](N)
var tcos = newSeq[float](N)
var ttan = newSeq[float](N)
var rsin = newSeq[float](N2)
var rcos = newSeq[float](N2)
var rtan = newSeq[float](N2)

proc rho(x, y: openArray[float], r: var openArray[float], i, n: int): float =
  if n < 0:
    return 0
  if n == 0:
    return y[i]

  let idx = (N - 1 - n) * (N - n) div 2 + i
  if r[idx] != r[idx]:
    r[idx] = (x[i] - x[i + n]) /
      (rho(x, y, r, i, n - 1) - rho(x, y, r, i + 1, n - 1)) +
       rho(x, y, r, i + 1, n - 2)
  return r[idx]

proc thiele(x, y: openArray[float], r: var openArray[float], xin: float, n: int): float =
  if n > N - 1:
    return 1
  return rho(x, y, r, 0, n) - rho(x, y, r, 0, n - 2) +
    (xin - x[n]) / thiele(x, y, r, xin, n + 1)

for i in 0..<N:
  xval[i] = float(i) * STEP
  tsin[i] = sin(xval[i])
  tcos[i] = cos(xval[i])
  ttan[i] = tsin[i] / tcos[i]

for i in 0..<N2:
  rsin[i] = NaN
  rcos[i] = NaN
  rtan[i] = NaN

echo fmt"{6 * thiele(tsin, xval, rsin, 0.5, 0):16.14f}"
echo fmt"{3 * thiele(tcos, xval, rcos, 0.5, 0):16.14f}"
echo fmt"{4 * thiele(ttan, xval, rtan, 1.0, 0):16.14f}"
