proc modInv(a0, b0: int): int =
  var (a, b, x0) = (a0, b0, 0)
  result = 1
  if b == 1: return
  while a > 1:
    result = result - (a div b) * x0
    a = a mod b
    swap a, b
    swap x0, result
  if result < 0: result += b0

echo modInv(42, 2017)
