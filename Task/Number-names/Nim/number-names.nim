import strutils, algorithm

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

for n in [0, -3, 5, -7, 11, -13, 17, -19, 23, -29]:
  echo align($n, 4)," -> ",spellInteger(n)

var n = 201021002001
while n != 0:
  echo align($n, 14)," -> ",spellInteger(n)
  n = n div -10
