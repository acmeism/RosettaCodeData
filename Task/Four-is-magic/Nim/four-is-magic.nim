import strutils

const

  Small = ["zero",    "one",     "two",       "three",    "four",
           "five",    "six",     "seven",     "eight",    "nine",
           "ten",     "eleven",  "twelve",    "thirteen", "fourteen",
           "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]

  Tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

  Illions = ["", " thousand", " million", " billion", " trillion", " quadrillion", " quintillion"]

#---------------------------------------------------------------------------------------------------

func say(n: int64): string =

  var n = n

  if n < 0:
    result = "negative "
    n = -n

  if n < 20:
    result &= Small[n]

  elif n < 100:
    result &= Tens[n div 10]
    let m = n mod 10
    if m != 0: result &= '-' & Small[m]

  elif n < 1000:
    result &= Small[n div 100] & " hundred"
    let m = n mod 100
    if m != 0: result &= ' ' & m.say()

  else:
    # Work from right to left.
    var sx = ""
    var i = 0
    while n > 0:
      let m = n mod 1000
      n = n div 1000
      if m != 0:
        var ix = m.say() & Illions[i]
        if sx.len > 0: ix &= " " & sx
        sx = ix
      inc i
    result &= sx

#---------------------------------------------------------------------------------------------------

func fourIsMagic(n: int64): string =
  var n = n
  var s = n.say().capitalizeAscii()
  result = s
  while n != 4:
    n = s.len.int64
    s = n.say()
    result &= " is " & s & ", " & s
  result &= " is magic."


#———————————————————————————————————————————————————————————————————————————————————————————————————

for n in [int64 0, 4, 6, 11, 13, 75, 100, 337, -164, int64.high]:
  echo fourIsMagic(n)
