import std/[algorithm, sequtils, strutils]

const MaxBase = 10

type UsedDigits = array[MaxBase, int]

var
  usedDigits: UsedDigits
  numbers: seq[int]


proc initPowerDigits(): array[MaxBase, array[MaxBase, int]] {.compileTime.} =
  for i in 1..<MaxBase:
    result[0][i] = 1
  for j in 1..<MaxBase:
    for i in 0..<MaxBase:
      result[j][i] = result[j - 1][i] * i

const PowerDigits = initPowerDigits()


proc calcNum(depth: int; used: UsedDigits) =
  var used = used
  var depth = depth
  if depth < 3: return
  var result = 0
  for i in 1..<MaxBase:
    if used[i] > 0:
      result += used[i] * PowerDigits[depth][i]

  if result == 0: return
  var n = result
  while true:
    let r = n div MaxBase
    dec used[n - r * MaxBase]
    n = r
    dec depth
    if r == 0: break
  if depth != 0: return

  var i = 1
  while i < MaxBase and used[i] == 0:
    inc i
  if i == MaxBase:
    numbers.add result


proc nextDigit(digit, depth: int) =
  var depth = depth
  if depth < MaxBase - 1:
    for i in digit..<MaxBase:
      inc usedDigits[digit]
      nextDigit(i, depth + 1)
      dec usedDigits[digit]
  let digit = if digit == 0: 1 else: digit
  for i in digit..<MaxBase:
    inc usedDigits[i]
    calcNum(depth, usedDigits)
    dec usedDigits[i]

nextDigit(0, 0)

numbers.sort()
numbers = numbers.deduplicate(true)
echo "Own digits power sums for N = 3 to 9 inclusive:"
echo numbers.join("\n")
