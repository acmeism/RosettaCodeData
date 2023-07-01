import strutils

func insequence(n: Positive): bool =
  ## Return true if "n" is in the sequence.
  if n < 10: return true
  var diff = 0
  var prev = n mod 10
  var n = n div 10
  while n != 0:
    let digit = n mod 10
    if digit < prev: inc diff
    elif digit > prev: dec diff
    prev = digit
    n = n div 10
  result = diff == 0

iterator a297712(): (int, int) =
  ## Yield the positions and the numbers of the sequence.
  var n = 1
  var pos = 0
  while true:
    if n.insequence:
      inc pos
      yield (pos, n)
    inc n

echo "First 200 numbers in the sequence:"
for (pos, n) in a297712():
  if pos <= 200:
    stdout.write ($n).align(3), if pos mod 20 == 0: '\n' else: ' '
  elif pos == 10_000_000:
    echo "\nTen millionth number in the sequence: ", n
    break
