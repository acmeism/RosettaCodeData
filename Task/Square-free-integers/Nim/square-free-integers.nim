import math, strutils


proc sieve(limit: Natural): seq[int] =
  result = @[2]
  var c = newSeq[bool](limit + 1)   # Composite = true.
  # No need to process even numbers > 2.
  var p = 3
  while true:
    let p2 = p * p
    if p2 > limit: break
    for i in countup(p2, limit, 2 * p):
      c[i] = true
    while true:
      inc p, 2
      if not c[p]: break
  for i in countup(3, limit, 2):
    if not c[i]: result.add i


proc squareFree(fromVal, toVal: Natural): seq[int] =
  let limit = int(sqrt(toVal.toFloat))
  let primes = sieve(limit)
  for i in fromVal..toVal:
    block check:
      for p in primes:
        let p2 = p * p
        if p2 > i: break
        if i mod p2 == 0:
          break check   # Not square free.
      result.add i


when isMainModule:

  const Trillion = 1_000_000_000_000

  echo "Square-free integers from 1 to 145:"
  var sf = squareFree(1, 145)
  for i, val in sf:
    if i > 0 and i mod 20 == 0:
      echo()
    stdout.write ($val).align(4)
  echo()

  echo "\nSquare-free integers from $1 to $2:\n".format(Trillion, Trillion + 145)
  sf = squareFree(Trillion, Trillion + 145)
  for i, val in sf:
    if i > 0 and i mod 5 == 0:
      echo()
    stdout.write ($val).align(14)
  echo()

  echo "\nNumber of square-free integers:\n"
  for n in [100, 1_000, 10_000, 100_000, 1_000_000]:
    echo "  from $1 to $2 = $3".format(1, n, squareFree(1, n).len)
