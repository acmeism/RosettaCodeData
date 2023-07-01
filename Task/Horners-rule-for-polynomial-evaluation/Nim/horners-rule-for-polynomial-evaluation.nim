# You can also just use `reversed` proc from stdlib `algorithm` module
iterator reversed[T](x: openArray[T]): T =
  for i in countdown(x.high, x.low):
    yield x[i]

proc horner[T](coeffs: openArray[T], x: T): int =
  for c in reversed(coeffs):
    result = result * x + c

echo horner([-19, 7, -4, 6], 3)
