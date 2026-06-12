import std/[math, strformat, sugar]

const
  D = 4                 # Sufficient to find the one thousandth first, as required.
  N = 10^D              # Size of sieve.
  M = 9 * (D + 1) * N   # Maximum value for the number to divide.

func digitalSum(n: Natural): int =
  ## Return the digital sum of "n".
  var n = n
  while n != 0:
    inc result, n mod 10
    n = n div 10

# Fill a sieve to find consummate numbers.
var isConsummate: array[1..N, bool]
for n in 1..M:
  let ds = n.digitalSum
  if n mod ds == 0:
    let q = n div ds
    if q <= N:
      isConsummate[q] = true

# Build list of inconsummate numbers.
let inconsummateNums = collect:
                         for n, c in isConsummate:
                           if not c: n

echo "First 50 inconsummate numbers in base 10:"
for i in 0..49:
  stdout.write &"{inconsummateNums[i]:3}"
  stdout.write if i mod 10 == 9: '\n' else: ' '

echo &"\nOne thousandth is {inconsummateNums[999]}."
