import strformat, strutils, sugar

func isPrime(n: Positive): bool =
  if n < 2: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true


iterator triplets(primes: openArray[int]): (int, int, int) =
  ## Yield the triplets.
  for i in 0..primes.high-2:
    let n = primes[i]
    for j in (i+1)..primes.high-1:
      let m = primes[j]
      for k in (j+1)..primes.high:
        let p = primes[k]
        if (n + m + p).isPrime:
          yield (n, m, p)


const Primes30 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
echo "List of strange unique prime triplets for n < m < p < 30:"
for (n, m, p) in Primes30.triplets():
  echo &"{n:2} + {m:2} + {p:2} = {n+m+p}"

echo()
const Primes1000 = collect(newSeq):
                     for n in 2..999:
                       if n.isPrime: n
var count = 0
for _ in Primes1000.triplets(): inc count
echo "Count of strange unique prime triplets for n < m < p < 1000: ", ($count).insertSep()
