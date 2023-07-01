import strutils, sugar

proc facmod(n, m: int): int =
  ## Compute (n - 1)! mod m.
  result = 1
  for k in 2..n:
    result = (result * k) mod m

func isPrime(n: int): bool = (facmod(n - 1, n) + 1) mod n == 0

let primes = collect(newSeq):
               for n in 2..100:
                 if n.isPrime: n

echo "Prime numbers between 2 and 100:"
echo primes.join(" ")
