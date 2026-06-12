import std/[algorithm, sequtils, strformat, strutils]
import integers

iterator magicNumbers(): tuple[length: int; value: Integer] =
  ## Yield the lengths and values of magic numbers.
  var magics = toSeq(newInteger(1)..newInteger(9))  # Ignore 0 for now.
  yield (1, newInteger(0))
  var length = 1
  while magics.len != 0:
    for n in magics: yield (length, n)
    var newMagics: seq[Integer]
    inc length
    for m in magics:
      for d in 0..9:
        let n = 10 * m + d
        if n mod length == 0:
          newMagics.add n
    magics = move(newMagics)

func isMinimallyPandigital(n: Integer; start: char): bool =
  ## Return true if "n" is minimally pandigital in "start" through 9.
  sorted($n) == toSeq(start..'9')


# Build list of magic numbers distributed by length.
var magicList: seq[seq[Integer]] = @[@[]]
var total = 0
for (length, n) in magicNumbers():
  if length > magicList.high:
    magicList.add @[]
  magicList[^1].add n
  inc total

echo &"Number of magic numbers: {insertSep($total)}"
echo &"Largest magic number: {insertSep($magicList[^1][^1])}"

echo "\nMagic number counts by number of digits:"
for length in 1..magicList.high:
  echo &"{length:2}: {magicList[length].len}"
echo()

stdout.write "Minimally pandigital 1-9 magic numbers: "
for n in magicList[9]:
  if n.isMinimallyPandigital('1'):
    stdout.write insertSep($n), ' '
echo()

stdout.write "Minimally pandigital 0-9 magic numbers: "
for n in magicList[10]:
  if n.isMinimallyPandigital('0'):
    stdout.write insertSep($n), ' '
echo()
