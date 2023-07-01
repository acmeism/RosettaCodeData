import std/[strformat, strutils]
import integers


func aDerivative(n: int | Integer): typeof(n) =
  ## Recursively compute the arithmetic derivative.
  ## The function works with normal integers or big integers.
  ## Using a cache to store the derivatives would improve the
  ## performance, but this is not needed for these tasks.
  if n < 0: return -aDerivative(-n)
  if n == 0 or n == 1: return 0
  if n == 2: return 1
  var d = 2
  result = 1
  while d * d <= n:
    if n mod d == 0:
      let q = n div d
      result = q * aDerivative(d) + d * aDerivative(q)
      break
    inc d


### Task ###

echo "Arithmetic derivatives for -99 through 100:"

# We can use an "int" variable here.
var col = 0
for n in -99..100:
  inc col
  stdout.write &"{aDerivative(n):>4}"
  stdout.write if col == 10: '\n' else: ' '
  if col == 10: col = 0


### Stretch task ###

echo()

# To avoid overflow, we have to use an "Integer" variable.
var n = Integer(1)
for m in 1..20:
  n *= 10
  let a = aDerivative(n)
  let left = &"D(10^{m}) / 7"
  echo &"{left:>12} = {a div 7}"
