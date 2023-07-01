## Nim currently doesn't have a BigInt standard library
## so we translate the version from Go which uses a
## deterministic approach, which is correct for all
## possible values in uint32.

proc isPrime*(n: uint32): bool =
  # bases of 2, 7, 61 are sufficient to cover 2^32
  case n
  of 0, 1: return false
  of 2, 7, 61: return true
  else: discard

  var
    nm1 = n-1
    d = nm1.int
    s = 0
    n = n.uint64

  while d mod 2 == 0:
    d = d shr 1
    s += 1

  for a in [2, 7, 61]:
    var
      x = 1.uint64
      p = a.uint64
      dr = d

    while dr > 0:
      if dr mod 2 == 1:
        x = x * p mod n
      p = p * p mod n
      dr = dr shr 1

    if x == 1 or x.uint32 == nm1:
      continue

    var r = 1
    while true:
      if r >= s:
        return false
      x = x * x mod n
      if x == 1:
        return false
      if x.uint32 == nm1:
        break
      r += 1

  return true

proc isPrime*(n: int32): bool =
  ## Overload for int32
  n >= 0 and n.uint32.isPrime

when isMainModule:
  const primeNumber1000 = 7919 # source: https://en.wikipedia.org/wiki/List_of_prime_numbers
  var
    i = 0u32
    numberPrimes = 0
  while true:
    if isPrime(i):
      if numberPrimes == 999:
        break
      numberPrimes += 1
    i += 1

  assert i == primeNumber1000
  assert isPrime(2u32)
  assert isPrime(31u32)
  assert isPrime(37u32)
  assert isPrime(1123u32)
  assert isPrime(492366587u32)
  assert isPrime(1645333507u32)
