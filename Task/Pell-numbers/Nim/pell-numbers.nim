import std/[strformat, strutils, sugar]
import integers

template isOdd(n: int): bool = (n and 1) != 0

iterator pellSequence[T](first, second: T; lim = -1): (int, T) =
  ## Yield the sucessive values of a Pell or Pell-Lucas sequence
  ## preceded by their rank.
  ## If "lim" is specified and greater than 2, only the "lim" first
  ## values are computed.
  ## The iterator works with "int" values or "Integer" values.
  var prev = first
  var curr = second
  yield (0, prev)
  yield (1, curr)
  var count = 2
  while true:
    swap prev, curr
    curr += 2 * prev
    yield (count, curr)
    inc count
    if count == lim: break

echo "First 10 Pell numbers:"
let p = collect:
          for (idx, val) in pellSequence(0, 1, 11): val
echo p[0..9].join(" ")

echo "\nFirst 10 Pell-Lucas numbers:"
let q = collect:
          for (idx, val) in pellSequence(2, 2, 11): val
echo q[0..9].join(" ")

echo "\nFirst 10 rational approximations of √2:"
for i in 1..10:
  let n = q[i] div 2
  let d = p[i]
  let r = &"{n}/{d}"
  echo &"{r:>9} = {n/d:.17}"

echo "\nFirst 10 Pell primes:"
# To avoid an overflow, we need to use Integer values here.
var indices: seq[int]
var count = 0
for (idx, p) in pellSequence(newInteger(0), newInteger(1)):
  if p.isPrime:
    echo p
    indices.add idx
    inc count
    if count == 10: break

echo "\nFirst 10 Pell primes indices:"
echo indices.join(" ")

echo "\nFirst 10 Newman-Shank-Williams numbers:"
count = 0
var prev: int
for (idx, p) in pellSequence(0, 1):
  if idx.isOdd:
    inc count
    stdout.write prev + p
    if count == 10: break
    stdout.write ' '
  else:
    prev = p
echo()

echo "\nFirst 10 near isosceles right triangles:"
count = 0
var sum = 0
for (idx, p) in pellSequence(0, 1):
  if idx.isOdd and sum != 0:
    echo (sum, sum + 1, p)
    inc count
    if count == 10: break
  inc sum, p
