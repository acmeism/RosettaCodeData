import std/[strformat, strutils, tables]
import Integers

# Build list of primes.import std/[strformat, strutils, tables]
import Integers


### Build list of primes ###

const N = 3100
var composite: array[(N - 3) shr 1, bool]
var n = 3
while n * n <= N:
  if not composite[(n - 3) shr 1]:
    for k in countup(n * n, composite.high, 2 * n):
      composite[(k - 3) shr 1] = true
  inc n, 2
var primes = @[2]
for i, comp in composite:
  if not comp:
    primes.add 2 * i + 3

if primes.len < 1000:
  quit &"Not enough primes ({primes.len}). Increase sieve size.", QuitFailure


### Sequences ###

# Common type for sequence procedures.
type SeqProc = proc(n: Natural): Integer

proc seq1(n: Natural): Integer =
  result = if n == 0: 1 else: 0

proc seq2(n: Natural): Integer =
  result = 1

proc seq3(n: Natural): Integer =
  result = if (n and 1) == 0: 1 else: -1

proc seq4(n: Natural): Integer =
  result = primes[n]

var fibCache: Table[Natural, Integer]
proc seq5(n: Natural): Integer =
  if n in fibCache: return fibCache[n]
  if n == 0 or n == 1: return 1
  result = seq5(n - 1) + seq5(n - 2)
  fibCache[n] = result

proc seq6(n: Natural): Integer =
  result = factorial(n)


### Boustrophedon transform ###

iterator boustrophedon(a: SeqProc): (int, Integer) =
  var bousCache: Table[(Natural, Natural), Integer]

  proc t(k, n: Natural): Integer =
    if (k, n) in bousCache: return bousCache[(k, n)]
    if n == 0: return a(k)
    result = t(k, n - 1) + t(k - 1, k - n)
    bousCache[(k, n)] = result

  var n = 0
  while true:
    yield (n, t(n, n))
    inc n


### Main ###

func compressed(str: string; size: int): string =
  ## Return a compressed value for long strings of digits.
  if str.len <= 2 * size: str
  else: &"{str[0..<size]}...{str[^size..^1]} ({str.len} digits)"

for (name, s) in {"One followed by an infinite series of zeros": SeqProc(seq1),
                  "Infinite sequence of ones": SeqProc(seq2),
                  "Alternating 1, -1, 1, -1": SeqProc(seq3),
                  "Sequence of prime numbers": SeqProc(seq4),
                  "Sequence of Fibonacci numbers": SeqProc(seq5),
                  "Sequence of factorial numbers": SeqProc(seq6)}:
  echo name, ':'
  for n, bn in s.boustrophedon():
    if n < 15:
      stdout.write bn
      stdout.write if n < 14: ' ' else: '\n'
    elif n == 999:
      echo "1000th element: ", compressed($bn, 20)
      break
  echo()
