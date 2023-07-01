import std/[sequtils, strformat, tables]

# Sieve to find the decomposition in prime factors.
const N = 2_700_000
var factors: array[1..N, CountTable[int]]
factors[1].inc(1)

for n in 2..N:
  if factors[n].len == 0:   # "n" is prime.
    var m = n               # Powers of "n"
    while m <= N:
      for k in countup(m, N, m):
        factors[k].inc(n)
      m *= n

type Category {.pure.} = enum Wasteful = "wasteful"
                              Equidigital = "equidigital"
                              Frugal = "frugal"

func digitCount(n, base: Positive): int =
  ## Return the number of digits of the representation of "n" in given base.
  var n = n.Natural
  while n != 0:
    inc result
    n = n div base

proc d(n, base: Positive): int =
  ## Compute "D(n)" in given base.
  for (p, e) in factors[n].pairs:
    inc result, p.digitCount(base)
    if e > 1: inc result, e.digitCount(base)

proc category(n, base: Positive): Category =
  ## Return the category of "n" in given base.
  let i = n.digitCount(base)
  let d = d(n, base)
  result = if i < d: Wasteful elif i > d: Frugal else: Equidigital


const N1 = 50
const N2 = 10_000
const Limit = 1_000_000

for base in [10, 11]:

  var counts1: array[Category, int]                   # Total counts.
  var counts2: array[Category, int]                   # Counts for n < Limit.
  var numbers1: array[Category, array[1..N1, int]]    # First N1 numbers in each category.
  var numbers2: array[Category, int]                  # Number at position N2 in each category.

  echo &"For base {base}."
  echo "===========\n"
  var n = 1
  while true:
    if n == Limit:
      counts2 = counts1
    let cat = n.category(base)
    inc counts1[cat]
    let c = counts1[cat]
    if c <= N1:
      numbers1[cat][c] = n
    elif c == N2:
      numbers2[cat] = n
    inc n
    if allIt(counts1, it >= N2) and n >= Limit: break

  for cat in Category.low..Category.high:
    echo &"First {N1} {cat} numbers:"
    for i, n in numbers1[cat]:
      stdout.write &"{n:4}"
      stdout.write if i mod 10 == 0: '\n' else: ' '
    echo &"\nThe {N2}th {cat} number is {numbers2[cat]}.\n"

  echo &"Among numbers less than {Limit}, there are:"
  for cat in Category.low..Category.high:
    echo &"- {counts2[cat]} {cat} numbers."
  echo '\n'
