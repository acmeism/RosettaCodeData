import math, complex, strutils

# Works with floats and complex numbers as input
proc fft[T: float | Complex[float]](x: openarray[T]): seq[Complex[float]] =
  let n = x.len
  if n == 0: return

  result.newSeq(n)

  if n == 1:
    result[0] = (when T is float: complex(x[0]) else: x[0])
    return

  var evens, odds = newSeq[T]()
  for i, v in x:
    if i mod 2 == 0: evens.add v
    else: odds.add v
  var (even, odd) = (fft(evens), fft(odds))

  let halfn = n div 2

  for k in 0 ..< halfn:
    let a = exp(complex(0.0, -2 * Pi * float(k) / float(n))) * odd[k]
    result[k] = even[k] + a
    result[k + halfn] = even[k] - a

for i in fft(@[1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]):
  echo formatFloat(abs(i), ffDecimal, 3)
