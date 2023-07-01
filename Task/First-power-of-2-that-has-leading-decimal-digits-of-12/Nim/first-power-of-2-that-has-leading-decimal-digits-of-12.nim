import math, strformat

const
  Lfloat64 = pow(2.0, 64)
  Log10_2_64 = int(Lfloat64 * log10(2.0))

#---------------------------------------------------------------------------------------------------

func ordinal(n: int): string =
  case n
  of 1: "1st"
  of 2: "2nd"
  of 3: "3rd"
  else: $n & "th"

#---------------------------------------------------------------------------------------------------

proc findExp(number, countLimit: int) =

  var i = number
  var digits = 1
  while i >= 10:
    digits *= 10
    i = i div 10

  var lmtLower, lmtUpper: uint64
  var log10num = log10((number + 1) / digits)
  if log10num >= 0.5:
    lmtUpper = if (number + 1) / digits < 10: uint(log10Num * (Lfloat64 * 0.5)) * 2 + uint(log10Num * 2)
               else: 0
    log10Num = log10(number / digits)
    lmtLower = uint(log10Num * (Lfloat64 * 0.5)) * 2 + uint(log10Num * 2)
  else:
    lmtUpper = uint(log10Num * Lfloat64)
    lmtLower = uint(log10(number / digits) * Lfloat64)

  var count = 0
  var frac64 = 0u64
  var p = 0
  if lmtUpper != 0:
    while true:
      inc p
      inc frac64, Log10_2_64
      if frac64 in lmtLower..lmtUpper:
        inc count
        if count >= countLimit:
          break
  else:
    # Searching for "999...".
    while true:
      inc p
      inc frac64, Log10_2_64
      if frac64 >= lmtLower:
        inc count
        if count >= countLimit:
          break

  echo fmt"""The {ordinal(count)} occurrence of 2 raised to a power""" &
       fmt""" whose product starts with "{number}" is {p}"""

#———————————————————————————————————————————————————————————————————————————————————————————————————

findExp(12, 1)
findExp(12, 2)

findExp(123, 45)
findExp(123, 12345)
findExp(123, 678910)
