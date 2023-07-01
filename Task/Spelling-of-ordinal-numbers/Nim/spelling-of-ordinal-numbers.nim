import strutils, algorithm, tables

const irregularOrdinals = {"one":    "first",
                           "two":    "second",
                           "three":  "third",
                           "five":   "fifth",
                           "eight":  "eighth",
                           "nine":   "ninth",
                           "twelve": "twelfth"}.toTable

const
  tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy",
          "eighty", "ninety"]
  small = ["zero", "one", "two", "three", "four", "five", "six", "seven",
           "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
           "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
  huge = ["", "", "million", "billion", "trillion", "quadrillion",
          "quintillion", "sextillion", "septillion", "octillion", "nonillion",
          "decillion"]

# Forward reference.
proc spellInteger(n: int64): string

proc nonzero(c: string; n: int64; connect = ""): string =
  if n == 0: "" else: connect & c & spellInteger(n)

proc lastAnd(num: string): string =
  if ',' in num:
    let pos =  num.rfind(',')
    var (pre, last) = if pos >= 0: (num[0 ..< pos], num[pos+1 .. num.high])
                      else: ("", num)
    if " and " notin last: last = " and" & last
    result = [pre, ",", last].join()
  else:
    result = num

proc big(e, n: int64): string =
  if e == 0:
    spellInteger(n)
  elif e == 1:
    spellInteger(n) & " thousand"
  else:
    spellInteger(n) & " " & huge[e]

iterator base1000Rev(n: int64): int64 =
  var n = n
  while n != 0:
    let r = n mod 1000
    n = n div 1000
    yield r

proc spellInteger(n: int64): string =
  if n < 0:
    "minus " & spellInteger(-n)
  elif n < 20:
    small[int(n)]
  elif n < 100:
    let a = n div 10
    let b = n mod 10
    tens[int(a)] & nonzero("-", b)
  elif n < 1000:
    let a = n div 100
    let b = n mod 100
    small[int(a)] & " hundred" & nonzero(" ", b, " and")
  else:
    var sq = newSeq[string]()
    var e = 0
    for x in base1000Rev(n):
      if x > 0: sq.add big(e, x)
      inc e
    reverse sq
    lastAnd(sq.join(", "))

proc num2ordinal(n: SomeInteger|SomeFloat): string =

  let n = n.int64

  var num = spellInteger(n)
  let hyphen = num.rsplit('-', 1)
  var number = num.rsplit(' ', 1)
  var delim = ' '
  if number[^1].len > hyphen[^1].len:
    number = hyphen
    delim = '-'

  if number[^1] in irregularOrdinals:
    number[^1] = delim & irregularOrdinals[number[^1]]
  elif number[^1].endswith('y'):
    number[^1] = delim & number[^1][0..^2] & "ieth"
  else:
    number[^1] = delim & number[^1] & "th"

  result = number.join()


when isMainModule:

  const
    tests1 = [int64 1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 8007006005004003, 123]
    tests2 = [0123.0, 1.23e2]

  for num in tests1:
    echo "$1 => $2".format(num, num2ordinal(num))
  for num in tests2:
    echo  "$1 => $2".format(num, num2ordinal(num))
