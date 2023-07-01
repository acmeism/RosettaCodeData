import std/strformat

template isEven(n: Natural): bool = (n and 1) == 0

func primeFactorSum(n: int): int =
  var n = n
  while n.isEven:
    inc result, 2
    n = n shr 1
  var p = 3
  var sq = 9
  while sq <= n:
    while n mod p == 0:
      inc result, p
      n = n div p
    inc sq, (p + 1) shl 2
    inc p, 2
  if n > 1:
    inc result, n

func primeDivisorSum(n: int): int =
  var n = n
  if n.isEven:
    inc result, 2
    n = n shr 1
    while n.isEven:
      n = n shr 1
  var p = 3
  var sq = 9
  while sq <= n:
    if n mod p == 0:
      inc result, p
      n = n div p
      while n mod p == 0:
        n = n div p
    inc sq, (p + 1) shl 2
    inc p, 2
  if n > 1:
    inc result, n

const Limit = 30

proc firstRuthAaronByFactors() =
  echo &"First {Limit} Ruth-Aaron numbers (factors):"
  var fsum1, fsum2 = 0
  var n = 2
  var count = 0
  while count < Limit:
    fsum2 = primeFactorSum(n)
    if fsum1 == fsum2:
      inc count
      stdout.write &"{n - 1:5}", if count mod 10 == 0: '\n' else: ' '
    fsum1 = fsum2
    inc n

proc firstRuthAaronByDivisors() =
  echo &"\nFirst {Limit} Ruth-Aaron numbers (divisors):"
  var dsum1, dsum2 = 0
  var n = 2
  var count = 0
  while count < Limit:
    dsum2 = primeDivisorSum(n)
    if dsum1 == dsum2:
      inc count
      stdout.write &"{n - 1:5}", if count mod 10 == 0: '\n' else: ' '
    dsum1 = dsum2
    inc n

proc firstRuthAaronTripleByFactors() =
  var fsum1, fsum2 = 0
  var n = 2
  while true:
    let fsum3 = primeFactorSum(n)
    if fsum1 == fsum3 and fsum2 == fsum3:
      echo &"\nFirst Ruth-Aaron triple (factors): {n - 2}"
      break
    fsum1 = fsum2
    fsum2 = fsum3
    inc n

proc firstRuthAaronTripleByDivisors() =
  var dsum1, dsum2 = 0
  var n = 2
  while true:
    let dsum3 = primeDivisorSum(n)
    if dsum1 == dsum3 and dsum2 == dsum3:
      echo &"\nFirst Ruth-Aaron triple (divisors): {n - 2}"
      break
    dsum1 = dsum2
    dsum2 = dsum3
    inc n

firstRuthAaronByFactors()
firstRuthAaronByDivisors()
firstRuthAaronTripleByFactors()
firstRuthAaronTripleByDivisors()
