from math import sqrt

iterator primesUpto(limit: int): int =
  let sqrtLimit = int(sqrt(float64(limit)))
  var composites = newSeq[bool](limit + 1)
  for n in 2 .. sqrtLimit: # cull to square root of limit
    if not composites[n]: # if prime -> cull its composites
      for c in countup(n *% n, limit +% 1, n): # start at ``n`` squared
        composites[c] = true
  for n in 2 .. limit: # separate iteration over results
    if not composites[n]:
      yield n

stdout.write "The primes up to 100 are:  "
for x in primesUpto(100):
   stdout.write(x, " ")
echo ""

var count = 0
for p in primesUpto(1000000):
  count += 1
echo "There are ", count, " primes up to 1000000."
