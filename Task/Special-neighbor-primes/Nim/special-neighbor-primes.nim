import strutils, sugar

const Max = 100 - 1

func isPrime(n: Positive): bool =
  if n == 1: return false
  if n mod 2 == 0: return n == 2
  for d in countup(3, n, 2):
    if d * d > n: break
    if n mod d == 0: return false
  result = true

const Primes = collect(newSeq):
                 for n in 2..Max:
                   if n.isPrime: n

let list = collect(newSeq):
             for i in 0..<Primes.high:
               let p1 = Primes[i]
               let p2 = Primes[i + 1]
               if (p1 + p2 - 1).isPrime: (p1, p2)

echo "Found $1 special neighbor primes less than $2:".format(list.len, Max + 1)
echo list.join(", ")
