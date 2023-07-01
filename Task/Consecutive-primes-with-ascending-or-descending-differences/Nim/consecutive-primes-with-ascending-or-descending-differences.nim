import math, strformat, sugar

const N = 1_000_000

####################################################################################################
# Erathostenes sieve.

var composite: array[2..N, bool]    # Initialized to false i.e. prime.

for n in 2..int(sqrt(float(N))):
  if not composite[n]:
    for k in countup(n * n, N, n):
      composite[k] = true

let primes = collect(newSeq):
               for n in 2..N:
                 if not composite[n]: n


####################################################################################################
# Longest sequences.

type Order {.pure.} = enum Ascending, Descending

proc longestSeq(order: Order): seq[int] =
  ## Return the longest sequence for the given order.

  let ascending = order == Ascending
  var
    currseq: seq[int]
    prevPrime = 2
    diff = if ascending: 0 else: N

  for prime in primes:
    let nextDiff = prime - prevPrime
    if nextDiff != diff and nextDiff > diff == ascending:
      currseq.add prime
    else:
      if currseq.len > result.len:
        result = move(currseq)
      currseq = @[prevPrime, prime]
    diff = nextDiff
    prevPrime = prime

  if currseq.len > result.len:
    result = move(currseq)


proc `$`(list: seq[int]): string =
  ## Return the representation of a list of primes with interleaved differences.
  var prevPrime: int
  for i, prime in list:
    if i != 0: result.add &" ({prime - prevPrime}) "
    result.addInt prime
    prevPrime = prime

echo "For primes < 1000000.\n"
echo "First longest sequence of consecutive primes with ascending differences:"
echo longestSeq(Ascending)
echo()
echo "First longest sequence of consecutive primes with descending differences:"
echo longestSeq(Descending)
