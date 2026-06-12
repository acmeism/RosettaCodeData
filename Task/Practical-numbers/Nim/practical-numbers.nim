import intsets, math, sequtils, strutils

func properDivisors(n: int): seq[int] =
  result = @[1]
  for i in 2..sqrt(n.toFloat).int:
    if n mod i == 0:
      let j = n div i
      result.add i
      if i != j: result.add j

func allSums(n: Positive): IntSet =
  let divs = n.properDivisors()
  var currSet: IntSet
  for d in divs:
    currSet.assign(result)  # Make a copy of the set.
    for sum in currSet:
      result.incl sum + d   # Add a new sum to the set.
    result.incl d           # Add the single value.

func isPractical(n: Positive): bool =
  toSeq(1..<n).toIntSet <= allSums(n)

var count = 0
for n in 1..333:
  if n.isPractical:
    inc count
    stdout.write ($n).align(3), if count mod 11 == 0: '\n' else: ' '
echo "Found ", count, " practical numbers between 1 and 333."
echo()
echo "666 is ", if 666.isPractical: "" else: "not ", "a practical number."
