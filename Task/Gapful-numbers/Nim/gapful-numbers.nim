import strutils


func gapfulDivisor(n: Positive): Positive =
  ## Return the gapful divisor of "n".

  let last = n mod 10
  var first = n div 10
  while first > 9:
    first = first div 10
  result = 10 * first + last


iterator gapful(start: Positive): Positive =
  ## Yield the gapful numbers starting from "start".

  var n = start
  while true:
    let d = n.gapfulDivisor()
    if n mod d == 0: yield n
    inc n


proc displayGapfulNumbers(start, num: Positive) =
  ## Display the first "num" gapful numbers greater or equal to "start".

  echo "\nFirst $1 gapful numbers ⩾ $2:".format(num, start)
  var count = 0
  var line: string
  for n in gapful(start):
    line.addSep(" ")
    line.add($n)
    inc count
    if count == num: break
  echo line


when isMainModule:
  displayGapfulNumbers(100, 30)
  displayGapfulNumbers(1_000_000, 15)
  displayGapfulNumbers(1_000_000_000, 10)
