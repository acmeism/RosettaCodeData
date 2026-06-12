import strutils, sugar

func isPrime(n: Positive): bool =
  if (n and 1) == 0: return n == 2
  var m = 3
  while m * m <= n:
    if n mod m == 0: return false
    inc m, 2
  result = true

func sumn(n: Positive): int =
  var n = n.int
  while n != 0:
    result += n mod 10
    n = n div 10

func isNicePrime(n: Positive): bool =
  if not n.isPrime: return false
  var n = n
  while n notin 1..9:
    n = sumn(n)
  result = n in [2, 3, 5, 7]

let list = collect(newSeq):
             for n in 501..999:
               if n.isNicePrime: n

echo "Found $1 nice primes between 501 and 999:".format(list.len)
for i, n in list:
  stdout.write n, if (i + 1) mod 10 == 0: '\n' else: ' '
echo()
