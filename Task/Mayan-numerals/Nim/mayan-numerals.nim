import algorithm

type Border = enum UL = "╔", UC = "╦", UR = "╗", LL = "╚", LC = "╩", LR = "╝", HB = "═", VB = "║"

const

  Mayan = ["    ", " ∙  ", " ∙∙ ", "∙∙∙ ", "∙∙∙∙"]

  M0 = " Θ  "
  M5 = "────"

type
  Digit = range[0..19]
  Numeral = array[4, string]
  MayanNumber = seq[Numeral]


func toBase20(n: Natural): seq[Digit] =
  ## Return "n" expressed as a sequence of base 20 digits.
  result.add(n mod 20)
  var n = n div 20
  while n != 0:
    result.add n mod 20
    n = n div 20
  result.reverse()


func toMayanNumeral(d: Digit): Numeral =
  ## Return the Numeral representing a base 20 digits.

  result = [Mayan[0], Mayan[0], Mayan[0], Mayan[0]]
  if d == 0:
    result[3] = M0
    return

  var d = d
  for i in countdown(3, 0):
    if d >= 5:
      result[i] = M5
      dec d, 5
    else:
      result[i] = Mayan[d]
      break


proc draw(mayans: MayanNumber) =
  ## Draw the representation fo a mayan number.

  let idx = mayans.high

  stdout.write UL
  for i in 0..idx:
    for j in 0..3: stdout.write HB
    if i < idx: stdout.write UC else: echo UR

  for i in 1..4:
    stdout.write VB
    for j in 0..idx: stdout.write mayans[j][i-1], VB
    stdout.write '\n'

  stdout.write LL
  for i in 0..idx:
    for j in 0..3: stdout.write HB
    if i < idx: stdout.write LC else: echo LR


when isMainModule:

  import sequtils, strutils

  for n in [4005, 8017, 326205, 886205, 1081439556]:
    echo "Converting $1 to Mayan:".format(n)
    let digits = n.toBase20()
    let mayans = digits.mapIt(it.toMayanNumeral)
    mayans.draw()
    echo ""
