import strformat

func isPrime(n: int64): bool =
  if n == 2 or n == 3:
    return true
  elif n < 2 or n mod 2 == 0 or n mod 3 == 0:
    return false
  var `div` = 5i64
  var `inc` = 2i64
  while `div` * `div` <= n:
    if n mod `div` == 0:
      return false
    `div` += `inc`
    `inc` = 6 - `inc`
  return true

for p in 2i64 .. 61:
  if not isPrime(p):
    continue
  for h3 in 2i64 ..< p:
    var g = h3 + p
    for d in 1 ..< g:
      if g * (p - 1) mod d != 0 or (d + p * p) mod h3 != 0:
        continue
      var q = 1 + (p - 1) * g div d
      if not isPrime(q):
        continue
      var r = 1 + (p * q div h3)
      if not isPrime(r) or (q * r) mod (p - 1) != 1:
        continue
      echo &"{p:5} × {q:5} × {r:5} = {p * q * r:10}"
