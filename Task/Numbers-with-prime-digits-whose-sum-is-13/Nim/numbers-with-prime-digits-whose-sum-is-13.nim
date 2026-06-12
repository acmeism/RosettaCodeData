import math, sequtils, strutils

type Digit = 0..9

proc toInt(s: seq[Digit]): int =
  ## Convert a sequence of digits to an integer.
  for n in s:
    result = 10 * result + n

const PrimeDigits = @[Digit 2, 3, 5, 7]

var list = PrimeDigits.mapIt(@[it])   # List of sequences of digits.
var result: seq[int]
while list.len != 0:
  var nextList: seq[seq[Digit]]       # List with one more digit.
  for digitSeq in list:
    let currSum = sum(digitSeq)
    for n in PrimeDigits:
      let newSum = currSum + n
      let newDigitSeq = digitSeq & n
      if newSum < 13: nextList.add newDigitSeq
      elif newSum == 13: result.add newDigitSeq.toInt
      else: break
  list = move(nextList)

for i, n in result:
  stdout.write ($n).align(6), if (i + 1) mod 9 == 0: '\n' else: ' '
echo()
