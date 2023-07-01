import math, strutils

template isEven(n: int): bool = (n and 1) == 0
template isOdd(n: int): bool = (n and 1) != 0


func getDivisors(n: int): seq[int] =
  result = @[1, n]
  for i in 2..sqrt(n.toFloat).int:
    if n mod i == 0:
      let j = n div i
      result.add i
      if i != j: result.add j


func isPartSum(divs: seq[int]; sum: int): bool =
  if sum == 0: return true
  if divs.len == 0: return false
  let last = divs[^1]
  let divs = divs[0..^2]
  result = isPartSum(divs, sum)
  if not result and last <= sum:
    result = isPartSum(divs, sum - last)


func isZumkeller(n: int): bool =
  let divs = n.getDivisors()
  let sum = sum(divs)
  # If "sum" is odd, it can't be split into two partitions with equal sums.
  if sum.isOdd: return false
  # If "n" is odd use "abundant odd number" optimization.
  if n.isOdd:
    let abundance = sum - 2 * n
    return abundance > 0 and abundance.isEven
  # If "n" and "sum" are both even, check if there's a partition which totals "sum / 2".
  result = isPartSum(divs, sum div 2)


when isMainModule:

  echo "The first 220 Zumkeller numbers are:"
  var n = 2
  var count = 0
  while count < 220:
    if n.isZumkeller:
      stdout.write align($n, 3)
      inc count
      stdout.write if count mod 20 == 0: '\n' else: ' '
    inc n
  echo()

  echo "The first 40 odd Zumkeller numbers are:"
  n = 3
  count = 0
  while count < 40:
    if n.isZumkeller:
      stdout.write align($n, 5)
      inc count
      stdout.write if count mod 10 == 0: '\n' else: ' '
    inc n, 2
  echo()

  echo "The first 40 odd Zumkeller numbers which don't end in 5 are:"
  n = 3
  count = 0
  while count < 40:
    if n mod 10 != 5 and n.isZumkeller:
      stdout.write align($n, 7)
      inc count
      stdout.write if count mod 8 == 0: '\n' else: ' '
    inc n, 2
