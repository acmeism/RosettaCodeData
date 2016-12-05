import math, rdstdin, strutils, algorithm
randomize()

proc shuffle[T](x: var seq[T]) =
  for i in countdown(x.high, 0):
    let j = random(i + 1)
    swap(x[i], x[j])

proc isSorted[T](s: openarray[T]): bool =
  var last = low(T)
  for c in s:
    if c < last:
      return false
    last = c
  return true

proc toString[T](s: openarray[T]): string =
  result = ""
  for i, x in s:
    if i > 0:
      result.add " "
    result.add($x)

echo """number reversal game
    Given a jumbled list of the numbers 1 to 9
    Show the list.
    Ask the player how many digits from the left to reverse.
    Reverse those digits then ask again.
    until all the digits end up in ascending order."""

var data = @[1,2,3,4,5,6,7,8,9]
var trials = 0
while isSorted data:
  shuffle data
while not isSorted data:
  inc trials
  var flip = parseInt readLineFromStdin(
    "#" & $trials & ": List: '" & toString(data) & "' Flip how many?: ")
  reverse(data, 0, flip - 1)

echo "You took ", trials, " attempts to put the digits in order!"
