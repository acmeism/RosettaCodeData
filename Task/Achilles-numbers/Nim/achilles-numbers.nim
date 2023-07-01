import std/[algorithm, sets, math, sequtils, strformat, strutils]

const MaxDigits = 15

func getPerfectPowers(maxExp: int): HashSet[int] =
  let upper = 10^maxExp
  for i in 2..int(sqrt(upper.toFloat)):
    var p = i
    while p < upper div i:
      p *= i
      result.incl p

let pps = getPerfectPowers(MaxDigits)

proc getAchilles(minExp, maxExp: int): HashSet[int] =
  let lower = 10^minExp
  let upper = 10^maxExp
  for b in 1..int(cbrt(upper.toFloat)):
    let b3 = b * b * b
    for a in 1..int(sqrt(upper.toFloat)):
      let p = b3 * a * a
      if p >= upper: break
      if p >= lower:
        if p notin pps: result.incl p


### Part 1 ###

let achillesSet = getAchilles(1, 6)
let achilles = sorted(achillesSet.toSeq)

echo "First 50 Achilles numbers:"
for i in 0..49:
  let n = achilles[i]
  stdout.write &"{n:>4}"
  stdout.write if i mod 10 == 9: '\n' else: ' '


### Part 2 ###

func totient(n: int): int =
  var n = n
  result = n
  var i = 2
  while i * i <= n:
    if n mod i == 0:
      while n mod i == 0:
        n = int(n / i)
      result -= int(result / i)
    if i == 2: i = 1
    inc i, 2
  if n > 1:
    result -= int(result / n)

echo "\nFirst 50 strong Achilles numbers:"
var strongAchilles: seq[int]
var count = 0
for n in achilles:
  let tot = totient(n)
  if tot in achillesSet:
    strongAchilles.add n
    inc count
    if count == 50: break

for i, n in strongAchilles:
  stdout.write &"{n:>6}"
  stdout.write if i mod 10 == 9: '\n' else: ' '


### Part 3 ###

echo "\nNumber of Achilles numbers with:"
for d in 2..MaxDigits:
  let ac = getAchilles(d - 1, d).len
  echo &"{d:>2} digits: {ac}"
