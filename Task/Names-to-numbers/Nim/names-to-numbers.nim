import re, sequtils, strformat, strutils, tables

const Names = {"one":         1u64,
               "two":         2u64,
               "three":       3u64,
               "four":        4u64,
               "five":        5u64,
               "six":         6u64,
               "seven":       7u64,
               "eight":       8u64,
               "nine":        9u64,
               "ten":         10u64,
               "eleven":      11u64,
               "twelve":      12u64,
               "thirteen":    13u64,
               "fourteen":    14u64,
               "fifteen":     15u64,
               "sixteen":     16u64,
               "seventeen":   17u64,
               "eighteen":    18u64,
               "nineteen":    19u64,
               "twenty":      20u64,
               "thirty":      30u64,
               "forty":       40u64,
               "fifty":       50u64,
               "sixty":       60u64,
               "seventy":     70u64,
               "eighty":      80u64,
               "ninety":      90u64,
               "hundred":     100u64,
               "thousand":    1000u64,
               "million":     1000000u64,
               "billion":     1000000000u64,
               "trillion":    1000000000000u64,
               "quadrillion": 1000000000000000u64,
               "quintillion": 1000000000000000000u64}.toTable

let Seps = re",|-| and | "
const Zeros = ["zero", "nought", "nil", "none", "nothing"]

template emitError(msg: string) = raise newException(ValueError, msg)


proc nameToNum(name: string): int64 =

  var text = name.strip().toLowerAscii
  let isNegative = text.startsWith("minus ")
  if isNegative: text.delete(0, 5)
  if text.startsWith("a"):
    text = "one" & text[1..^1]
  let words = text.split(Seps).filterIt(it.len != 0)
  if words.len == 1 and words[0] in Zeros:
    return 0

  var
    multiplier = 1u64
    lastNum, sum = 0u64
  for i in countdown(words.high, 0):
    let num = Names.getOrDefault(words[i], 0)
    if num == 0:
      emitError(&"'{words[i]}' is not a valid number")
    elif num == lastNum:
      emitError(&"'{name}' is not a well formed numeric string")
    elif num >= 1000:
      if lastNum >= 100:
        emitError(&"'{name}' is not a well formed numeric string")
      multiplier = num
      if i == 0: sum += multiplier
    elif num >= 100:
      multiplier *= 100
      if i == 0: sum += multiplier
    elif num >= 20:
      if lastNum in 10u64..90u64:
        emitError(&"'{name}' is not a well formed numeric string")
      sum += num * multiplier
    else:
      if lastNum in 1u64..90u64:
        emitError(&"'{name}' is not a well formed numeric string")
      sum += num * multiplier
    lastNum = num

  if isNegative and sum == uint64(int64.high) + 1:
    return int64.low
  if sum > uint64(int64.high):
    emitError(&"'$name' is outside the range of a 64 bits integer")

  result = if isNegative: -int64(sum) else: int64(sum)


when isMainModule:
  let names = [
    "none",
    "one",
    "twenty-five",
    "minus one hundred and seventeen",
    "hundred and fifty-six",
    "minus two thousand two",
    "nine thousand, seven hundred, one",
    "minus six hundred and twenty six thousand, eight hundred and fourteen",
    "four million, seven hundred thousand, three hundred and eighty-six",
    "fifty-one billion, two hundred and fifty-two million, seventeen thousand, one hundred eighty-four",
    "two hundred and one billion, twenty-one million, two thousand and one",
    "minus three hundred trillion, nine million, four hundred and one thousand and thirty-one",
    "seventeen quadrillion, one hundred thirty-seven",
    "a quintillion, eight trillion and five",
    "minus nine quintillion, two hundred and twenty-three quadrillion, three hundred and seventy-two trillion, thirty-six billion, eight hundred and fifty-four million, seven hundred and seventy-five thousand, eight hundred and eight"]

for name in names:
  echo ($nametoNum(name)).align(20), " = ", name
