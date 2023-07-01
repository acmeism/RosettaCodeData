import strutils

const N = 8_000_000

type Mark {.pure.} = enum None, Mark1, Mark2

var mark: array[1..N, Mark]
for n in countup(4, N, 3): mark[n] = Mark1


var count = 0           # Count of primes.
var list100: seq[int]   # First 100 primes.
var last = 0            # Millionth prime.
var step = 5            # Current step for marking.

for n in 1..N:
  case mark[n]
  of None:
    # Add/count a new odd prime.
    inc count
    if count <= 100:
      list100.add 2 * n + 1
    elif count == 1_000_000:
      last = 2 * n + 1
      break
  of Mark1:
    # Mark new numbers using current step.
    if n > 4:
      for k in countup(n + step, N, step):
        if mark[k] == None: mark[k] = Mark2
      inc step, 2
  of Mark2:
    # Ignore this number.
    discard


echo "First 100 Sundaram primes:"
for i, n in list100:
  stdout.write ($n).align(3), if (i + 1) mod 10 == 0: '\n' else: ' '
echo()
if last == 0:
  quit "Not enough values in sieve. Found only $#.".format(count), QuitFailure
echo "The millionth Sundaram prime is ", ($last).insertSep()
