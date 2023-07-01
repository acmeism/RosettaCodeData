import algorithm, sequtils, strutils
import bignum

const
  N = 50      # Number of fortunate numbers.
  Lim = 75    # Number of primorials to compute.


iterator primorials(lim: Positive): Int =
  var prime = newInt(2)
  var primorial = newInt(1)
  for _ in 1..lim:
    primorial *= prime
    prime = prime.nextPrime()
    yield primorial


var list: seq[int]
for p in primorials(Lim):
  var m = 3
  while true:
    if probablyPrime(p + m, 25) != 0:
      list.add m
      break
    inc m, 2

list.sort()
list = list.deduplicate(true)
if list.len < N:
  quit "Not enough values. Wanted $1, got $2.".format(N, list.len), QuitFailure
list.setLen(N)
echo "First $# fortunate numbers:".format(N)
for i, m in list:
  stdout.write ($m).align(3), if (i + 1) mod 10 == 0: '\n' else: ' '
