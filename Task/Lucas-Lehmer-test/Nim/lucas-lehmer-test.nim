import math

proc isPrime(a: int): bool =
  if a == 2: return true
  if a < 2 or a mod 2 == 0: return false
  for i in countup(3, int sqrt(float a), 2):
    if a mod i == 0:
      return false
  return true

proc isMersennePrime(p: int): bool =
  if p == 2: return true
  let mp = (1'i64 shl p) - 1
  var s = 4'i64
  for i in 3 .. p:
    s = (s * s - 2) mod mp
  result = s == 0

let upb = int((log2 float int64.high) / 2)
echo " Mersenne primes:"
for p in 2 .. upb:
  if isPrime(p) and isMersennePrime(p):
    stdout.write " M",p
echo ""
