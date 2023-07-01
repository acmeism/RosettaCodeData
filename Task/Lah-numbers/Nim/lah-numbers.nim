import math, strutils
import bignum

func lah[T: int | Int](n, k: T; signed = false): T =
  if n == 0 or k == 0 or k > n: return when T is int: 0 else: newInt(0)
  if n == k: return when T is int: 1 else: newInt(1)
  if k == 1: return fac(n)
  result = binom(n, k) * binom(n - 1, k - 1) * fac(n - k)
  if signed and (n and 1) != 0: result = -result

proc printLahTable(kmax: int) =
  stdout.write "  "
  for k in 0..kmax:
    stdout.write ($k).align(12)
  stdout.write('\n')
  for n in 0..kmax:
    stdout.write ($n).align(2)
    for k in 0..n:
      stdout.write ($lah(n, k)).align(12)
    stdout.write('\n')

printLahTable(12)

var maxval = newInt(0)
let n = newInt(100)
for k in newInt(0)..newInt(100):
  let val = lah(n, k)
  if val > maxval: maxval = val
echo "\nThe maximum value of lah(100, k) is ", maxval
