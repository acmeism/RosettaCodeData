import strformat

func digitsSum(n, sum: uint64): uint64 =
  ## Returns the sum of the digits of n given the sum of the digits of n - 1.
  result = sum + 1
  var n = n
  while n > 0 and n mod 10 == 0:
    dec result, 9
    n = n div 10

func divisible(n, d: uint64): bool {.inline.} =
  if (d and 1) == 0 and (n and 1) == 1:
    return false
  result = n mod d == 0

when isMainModule:

  echo "Gap index  Gap  Niven index  Niven number"

  var
    niven, gap, sum, nivenIndex = 0u64
    previous, gapIndex = 1u64

  while gapIndex <= 32:
    inc niven
    sum = digitsSum(niven, sum)
    if divisible(niven, sum):
      if niven > previous + gap:
        gap = niven - previous
        echo fmt"{gapIndex:9d} {gap:4d} {nivenIndex:12d} {previous:13d}"
        inc gapIndex
      previous = niven
      inc nivenIndex
