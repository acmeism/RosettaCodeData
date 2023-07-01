import std/[math, intsets, strformat]

func digits(n: Natural): seq[int] =
  ## Return the digits of "n" in reverse order.
  var n = n
  while true:
    result.add n mod 10
    n = n div 10
    if n == 0: break

var largest = 0

proc isColorful(n: Natural): bool =
  ## Return true if "n" is colorful.
  if n in 0..9: return true
  let digSeq = n.digits
  var digSet: set[0..9]
  for d in digSeq:
    if d <= 1 or d in digSet:
      return false
    digSet.incl d
  var products = digSeq.toIntSet()
  for i in 0..<digSeq.high:
    for j in (i + 1)..digSeq.high:
      let p = prod(digSeq.toOpenArray(i, j))
      if p in products:
        return false
      products.incl p
  if n > largest: largest = n
  result = true

echo "Colorful numbers for 1:25, 26:50, 51:75, and 76:100:"
for i in countup(1, 100, 25):
  for j in 0..24:
    if isColorful(i + j):
      stdout.write &"{i + j: 5}"
  echo()

echo()
var csum = 0
for i in 0..7:
  let j = if i == 0: 0 else: 10^i
  let k = 10^(i+1) - 1
  var n = 0
  for x in j..k:
    if x.isColorful: inc n
  inc csum, n
  echo &"The count of colorful numbers between {j} and {k} is {n}."

echo()
echo &"The largest possible colorful number is {largest}."
echo &"The total number of colorful numbers is {csum}."
