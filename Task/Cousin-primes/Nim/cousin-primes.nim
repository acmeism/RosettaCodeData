import sets, strutils, sugar

const N = 1000

func isPrime(n: Positive): bool {.compileTime.} =
  if (n and 1) == 0: return n == 2
  var m = 3
  while m * m <= n:
    if n mod m == 0: return false
    inc m, 2
  result = true

const
  PrimeList = collect(newSeq):
                for n in 2..N:
                  if n.isPrime: n
  PrimeSet = PrimeList.toHashSet

let cousinList = collect(newSeq):
                   for n in PrimeList:
                     if (n + 4) in PrimeSet: (n, n + 4)

echo "Found $# cousin primes less than $#:".format(cousinList.len, N)
for i, cousins in cousinList:
  stdout.write ($cousins).center(10)
  stdout.write if (i+1) mod 7 == 0: '\n' else: ' '
echo()
