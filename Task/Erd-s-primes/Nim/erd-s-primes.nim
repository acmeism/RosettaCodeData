import math, sets, strutils, sugar

const N = 1_000_000

# Sieve of Erathostenes.
var isComposite: array[2..N, bool]
for n in 2..N:
  let n2 = n * n
  if n2 > N: break
  if not isComposite[n]:
    for k in countup(n2, N, n):
      isComposite[k] = true

template isPrime(n: int): bool = n > 1 and not isComposite[n]

let primeList = collect(newSeq):
                  for n in 2..N:
                    if n.isPrime: n

const Factorials = collect(newSeq):
                     for n in 1..20:
                       if fac(n) >= N: break
                       fac(n)


proc isErdösPrime(p: int): bool =
  ## Check if prime "p" is an Erdös prime.
  for f in Factorials:
    if f >= p: break
    if (p - f).isPrime: return false
  result = true


let erdösList2500 = collect(newSeq):
                      for p in primeList:
                        if p >= 2500: break
                        if p.isErdösPrime: p

echo "Found $# Erdös primes less than 2500:".format(erdösList2500.len)
for i, prime in erdösList2500:
  stdout.write ($prime).align(5)
  stdout.write if (i+1) mod 10 == 0: '\n' else: ' '
echo()

var erdös7875: int
var count = 0
for p in primeList:
  if p.isErdösPrime: inc count
  if count == 7875:
    erdös7875 = p
    break
echo "\nThe 7875th Erdös prime is $#.".format(erdös7875)
