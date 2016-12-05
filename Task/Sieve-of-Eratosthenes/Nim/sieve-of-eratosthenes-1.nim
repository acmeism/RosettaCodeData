import math

iterator iprimes_upto(limit: int): int =
  let sqrtlmt = int(sqrt float64(limit))
  var is_cmpsts = newSeq[bool](limit + 1)
  is_cmpsts[0] = true; is_cmpsts[1] = true
  for n in 2 .. sqrtlmt: # cull to square root of limit
    if not is_cmpsts[n]: # if prime -> cull its composites
      for i in countup((n *% n), limit+1, n): # start at ``n`` squared
        is_cmpsts[i] = true
  for n in 2 .. limit: # separate iteration over results
    if not is_cmpsts[n]:
      yield n

echo("Primes are:")
for x in iprimes_upto(100):
   write(stdout, x, " ")
echo ""

var count = 0
for p in iprimes_upto(1000000):
  count += 1
writeLine stdout, "There are ", count, " primes up to 1000000."
