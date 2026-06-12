import algorithm, strutils, sugar

const
  M = 1000 - 1
  N = M div 3   # Minimal value for "p" is 3.

# Sieve of Eratosthenes.
var composite: array[3..N, bool]

for n in countup(3, N, 2):
  let n2 = n * n
  if n2 > N: break
  if not composite[n]:
    for k in countup(n2, N, 2 * n):
      composite[k] = true

let primes = collect(newSeq):
               for n in countup(3, N, 2):
                 if not composite[n]: n

var result: seq[int]
for i in 0..<primes.high:
  let p = primes[i]
  for j in (i+1)..primes.high:
    let q = primes[j]
    if p * q > M: break
    result.add p * q
result.sort()

for i, n in result:
  stdout.write ($n).align(3), if (i + 1) mod 20 == 0: '\n' else: ' '
echo()
