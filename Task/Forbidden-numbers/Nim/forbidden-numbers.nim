import std/[math, strformat, strutils]

const Max = 500_000

func isForbidden(num: Positive): bool =
  ## Return "true" is "n" is a forbidden number.
  var fours = num
  var pow4 = 0
  while fours > 1 and (fours and 3) == 0:
    fours = fours shr 2
    inc pow4
  result = (num div 4^pow4 and 7) == 7

iterator forbiddenNumbers(): int =
  var n = 1
  while true:
    if n.isForbidden:
      yield n
    inc n

var count = 0
var lim = 500
for n in forbiddenNumbers():
  inc count
  if count <= 50:
    stdout.write &"{n:>3}"
    stdout.write if count mod 10 == 0: '\n' else: ' '
    if count == 50: echo()
  elif n > lim:
    echo &"Numbers of forbidden numbers up to {insertSep($lim)}: {insertSep($(count - 1))}"
    lim *= 10
    if lim > Max:
      break
