proc mulInv(a0, b0): int =
  var (a, b, x0) = (a0, b0, 0)
  result = 1
  if b == 1: return
  while a > 1:
    let q = a div b
    a = a mod b
    swap a, b
    result = result - q * x0
    swap x0, result
  if result < 0: result += b0

proc chineseRemainder[T](n, a: T): int =
  var prod = 1
  var sum = 0
  for x in n: prod *= x

  for i in 0 .. <n.len:
    let p = prod div n[i]
    sum += a[i] * mulInv(p, n[i]) * p

  sum mod prod

echo chineseRemainder([3,5,7], [2,3,2])
