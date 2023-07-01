import math, sequtils, strformat, strutils, times

proc getStep(n: int64): int64 {.inline.} =
  result = 1 + n shl 2 - n shr 1 shl 1

proc primeFac(n: int64): seq[int64] =
  var maxq = int64(sqrt(float(n)))
  var d = 1
  var q: int64 = 2 + (n and 1)   # Start with 2 or 3 according to oddity.
  while q <= maxq and n %% q != 0:
    q = getStep(d)
    inc d
  if q <= maxq:
    let q1 = primeFac(n /% q)
    let q2 = primeFac(q)
    result = concat(q2, q1, result)
  else:
    result.add(n)

iterator primes(limit: int): int =
  var isPrime = newSeq[bool](limit + 1)
  for n in 2..limit: isPrime[n] = true
  for n in 2..limit:
    if isPrime[n]:
      yield n
      for i in countup(n *% n, limit, n):
        isPrime[i] = false

when isMainModule:

  # Example: calculate factors of Mersenne numbers from M2 to M59.
  for m in primes(59):
    let p = 2i64^m - 1
    let s = &"2^{m}-1"
    stdout.write &"{s:<6} = {p} with factors: "
    let start = cpuTime()
    stdout.write primeFac(p).join(", ")
    echo &" => {(1000 * (cpuTime() - start)).toInt} ms"
