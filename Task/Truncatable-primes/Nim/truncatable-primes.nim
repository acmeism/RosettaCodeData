import sets, strutils, algorithm

proc primes(n: int64): seq[int64] =
  result = @[]
  var multiples = initSet[int64]()
  for i in 2..n:
    if i notin multiples:
      result.add i
      for j in countup(i*i, n, i.int):
        multiples.incl j

proc truncatablePrime(n: int64): tuple[left: int64, right: int64] =
  var
    primelist: seq[string] = @[]
  for x in primes(n):
    primelist.add($x)
  reverse primelist
  var primeset = toSet primelist
  for n in primelist:
    var alltruncs = initSet[string]()
    for i in 0..n.len-1:
      alltruncs.incl n[i..n.high]
    if alltruncs <= primeset:
      result.left = parseInt(n)
      break
  for n in primelist:
    var alltruncs = initSet[string]()
    for i in 0..n.len-1:
      alltruncs.incl n[0..i]
    if alltruncs <= primeset:
      result.right = parseInt(n)
      break

echo truncatablePrime(1000000'i64)
