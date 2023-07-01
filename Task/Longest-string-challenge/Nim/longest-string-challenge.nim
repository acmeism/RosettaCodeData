import strutils

const

  # Define int constants instead of an enum to use only ints and strings.
  Shorter = -1
  SameLength = 0
  Longer = 1

type LengthComparison = range[Shorter..Longer]

func cmpLength(a, b: string): LengthComparison =
  let a = repeat(' ', a.len)
  let b = repeat(' ', b.len)
  result = if a in b: (if b in a: SameLength else: Shorter) else: Longer

var longest = ""
var result = ""
for line in "longest_string_challenge.txt".lines:
  case cmpLength(line, longest)
  of Shorter:
    discard
  of SameLength:
    result.add '\n' & line
  of Longer:
    longest = line
    result = line

echo result
