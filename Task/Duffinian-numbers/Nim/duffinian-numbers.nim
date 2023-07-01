import std/[algorithm, math, strformat]

const MaxNumber = 500_000

# Construct a table of the divisor counts.
var ds: array[1..MaxNumber, int]
ds.fill 1
for i in 2..MaxNumber:
  for j in countup(i, MaxNumber, i):
    ds[j] += i

# Set the divisor counts of non-Duffinian numbers to 0.
ds[1] = 0   # 1 is not Duffinian.
for n in 2..MaxNumber:
  let nds = ds[n]
  if nds == n + 1 or gcd(n, nds) != 1:
    # "n" is prime or is not relatively prime to its divisor sum.
    ds[n] = 0

# Show the first 50 Duffinian numbers.
echo "First 50 Duffinian numbers:"
var dcount = 0
var n = 1
while dcount < 50:
  if ds[n] != 0:
    stdout.write &" {n:3}"
    inc dcount
    if dcount mod 25 == 0:
      echo()
  inc n
echo()

# Show the Duffinian triplets below MaxNumber.
echo &"The Duffinian triplets up to {MaxNumber}:"
dcount = 0
for n in 3..MaxNumber:
  if ds[n - 2] != 0 and ds[n - 1] != 0 and ds[n] != 0:
    inc dcount
    stdout.write &" {(n - 2, n - 1, n): ^24}"
    stdout.write if dcount mod 4 == 0: '\n' else: ' '
echo()
