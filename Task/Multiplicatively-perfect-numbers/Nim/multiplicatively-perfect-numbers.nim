import std/strformat

func isMPN(n: int32): bool =
  ## Return true if "n" is a multiplicatively perfect number.
  ## We consider than 1 is not an MPN.
  var first, second = 0i32   # First and second proper divisors.
  let delta = 1 + (n and 1)
  var d = delta + 1
  while d * d <= n:
    if n mod d == 0:
      if second != 0: return false  # More than two proper divisors.
      first = d
      let q = n div d
      if q != d: second = q
    inc d, delta
  result = first * second == n

### Task ###
var count = 0
for n in 1i32..499i32:
  if n.isMPN:
    inc count
    stdout.write &"{n:3}"
    stdout.write if count mod 10 == 0: '\n' else: ' '
echo '\n'

### Stretch task ###

func isPrime(n: int32): bool =
  ## Return true if "n" is prime.
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  var delta = 2
  while k * k <= n:
    if n mod k == 0: return false
    inc k, delta
    delta = 6 - delta
  result = true

var mpnCount = 0
var limit = 500i32
var ns, nc = 3i32
var squares, cubes = 1i32
var n = 1i32
while true:
  inc n
  if n == limit:
    while ns * ns < limit:
      if ns.isPrime: inc squares
      inc ns, 2
    while nc * nc * nc < limit:
      if nc.isPrime: inc cubes
      inc nc, 2
    echo &"Under {limit} there are {mpnCount} MPNs and {mpnCount - cubes + squares} semi-primes."
    if limit == 500_000: break
    limit *= 10
  if n.isMPN: inc mpnCount
