import strformat, sugar

func isPrime(n: Natural): bool =
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

func isNonDecreasing(n: int): bool =
  var n = n
  var prev = 10
  while n != 0:
    let d = n mod 10
    if d > prev: return false
    prev = d
    n = n div 10
  result = true

let result = collect(newSeq):
               for n in 2..999:
                 if n.isPrime and n.isNonDecreasing: n

echo &"Found {result.len} primes:"
for i, n in result:
  stdout.write &"{n:3}", if (i + 1) mod 10 == 0: '\n' else: ' '
