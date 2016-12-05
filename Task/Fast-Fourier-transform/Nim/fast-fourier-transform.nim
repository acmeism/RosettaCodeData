import math, complex, strutils

proc toComplex(x: float): TComplex = result.re = x
proc toComplex(x: TComplex): TComplex = x

# Works with floats and complex numbers as input
proc fft[T](x: openarray[T]): seq[TComplex] =
  let n = x.len
  result = newSeq[TComplex]()
  if n <= 1:
    for v in x: result.add toComplex(v)
    return
  var evens, odds = newSeq[T]()
  for i, v in x:
    if i mod 2 == 0: evens.add v
    else: odds.add v
  var (even, odd) = (fft(evens), fft(odds))

  for k in 0 .. < n div 2:
    result.add(even[k] + exp((0.0, -2*pi*float(k)/float(n))) * odd[k])

  for k in 0 .. < n div 2:
    result.add(even[k] - exp((0.0, -2*pi*float(k)/float(n))) * odd[k])

for i in fft(@[1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]):
  echo formatFloat(abs(i), ffDecimal, 3)
