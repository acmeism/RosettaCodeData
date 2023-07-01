const epsilon : float64 = 1.0e-15
var fact : int64 = 1
var e : float64 = 2.0
var e0 : float64 = 0.0
var n : int64 = 2

while abs(e - e0) >= epsilon:
  e0 = e
  fact = fact * n
  inc(n)
  e = e + 1.0 / fact.float64

echo e
