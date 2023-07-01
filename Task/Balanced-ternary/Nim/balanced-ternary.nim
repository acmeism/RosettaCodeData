import std/[strformat, tables]

type

  # Trit definition.
  Trit = range[-1'i8..1'i8]

  # Balanced ternary number as a sequence of trits stored in little endian way.
  BTernary = seq[Trit]

const

  # Textual representation of trits.
  Trits: array[Trit, char] = ['-', '0', '+']

  # Symbolic names used for trits.
  TN = Trit(-1)
  TZ = Trit(0)
  TP = Trit(1)

  # Table to convert the result of classic addition to balanced ternary numbers.
  AddTable = {-2: @[TP, TN], -1: @[TN], 0: @[TZ], 1: @[TP], 2: @[TN, TP]}.toTable()

  # Mapping from modulo to trits (used for conversion from int to balanced ternary).
  ModTrits: array[-2..2, Trit] = [TP, TN, TZ, TP, TN]


#---------------------------------------------------------------------------------------------------

func normalize(bt: var BTernary) =
  ## Remove the extra zero trits at head of a BTernary number.
  var i = bt.high
  while i >= 0 and bt[i] == 0:
    dec i
  bt.setlen(if i < 0: 1 else: i + 1)

#---------------------------------------------------------------------------------------------------

func `+`*(a, b: BTernary): BTernary =
  ## Add two BTernary numbers.

  # Prepare operands.
  var (a, b) = (a, b)
  if a.len < b.len:
    a.setLen(b.len)
  else:
    b.setLen(a.len)

  # Perform addition trit per trit.
  var carry = TZ
  for i in 0..<a.len:
    var s = AddTable[a[i] + b[i]]
    if carry != TZ:
      s = s + @[carry]
    carry = if s.len > 1: s[1] else: TZ
    result.add(s[0])

  # Append the carry to the result if it is not null.
  if carry != TZ:
    result.add(carry)

#---------------------------------------------------------------------------------------------------

func `+=`*(a: var BTernary; b: BTernary) {.inline.} =
  ## Increment a BTernary number.
  a = a + b

#---------------------------------------------------------------------------------------------------

func `-`(a: BTernary): BTernary =
  ## Negate a BTernary number.
  result.setLen(a.len)
  for i, t in a:
    result[i] = -t

#---------------------------------------------------------------------------------------------------

func `-`*(a, b: BTernary): BTernary {.inline.} =
  ## Subtract a BTernary number to another.
  a + -b

#---------------------------------------------------------------------------------------------------

func `-=`*(a: var BTernary; b: BTernary) {.inline.} =
  ## Decrement a BTernary number.
  a = a + -b

#---------------------------------------------------------------------------------------------------

func `*`*(a, b: BTernary): BTernary =
  ## Multiply two BTernary numbers.

  var start: BTernary
  let na = -a

  # Loop on each trit of "b" and add directly a whole row.
  for t in b:
    case t
    of TP: result += start & a
    of TZ: discard
    of TN: result += start & na
    start.add(TZ)   # Shift next row.
  result.normalize()

#---------------------------------------------------------------------------------------------------

func toTrit*(c: char): Trit =
  ## Convert a char to a trit.
  case c
  of '-': -1
  of '0': 0
  of '+': 1
  else:
    raise newException(ValueError, fmt"Invalid trit: '{c}'")

#---------------------------------------------------------------------------------------------------

func `$`*(bt: BTernary): string =
  ## Return the string representation of a BTernary number.
  result.setLen(bt.len)
  for i, t in bt:
    result[^(i + 1)] = Trits[t]

#---------------------------------------------------------------------------------------------------

func toBTernary*(s: string): BTernary =
  ## Build a BTernary number from its string representation.
  result.setLen(s.len)
  for i, c in s:
    result[^(i + 1)] = c.toTrit()

#---------------------------------------------------------------------------------------------------

func toInt*(bt: BTernary): int =
  ## Convert a BTernary number to an integer.
  ## An overflow error is raised if the result cannot fit in an integer.
  var m = 1
  for t in bt:
    result += m * t
    m *= 3

#---------------------------------------------------------------------------------------------------

func toBTernary(val: int): BTernary =
  ## Convert an integer to a BTernary number.
  var val = val
  while true:
    let trit = ModTrits[val mod 3]
    result.add(trit)
    val = (val - trit) div 3
    if val == 0:
      break

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  let a = "+-0++0+".toBTernary
  let b = -436.toBTernary
  let c = "+-++-".toBTernary

  echo "Balanced ternary numbers:"
  echo fmt"a = {a}"
  echo fmt"b = {b}"
  echo fmt"c = {c}"
  echo ""

  echo "Their decimal representation:"
  echo fmt"a = {a.toInt: 4d}"
  echo fmt"b = {b.toInt: 4d}"
  echo fmt"c = {c.toInt: 4d}"
  echo ""

  let x = a * (b - c)
  echo "a × (b - c):"
  echo fmt"– in ternary: {x}"
  echo fmt"– in decimal: {x.toInt}"
