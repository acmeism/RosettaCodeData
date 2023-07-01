import random, sequtils, strutils

type LatinSquare = seq[seq[char]]

proc get[T](s: set[T]): T =
  ## Return the first element of a set.
  for n in s:
    return n

proc letterAt(n: Natural): char {.inline.} = chr(ord('A') - 1 + n)


proc latinSquare(n: Positive): LatinSquare =
  result = newSeqWith(n, toSeq(letterAt(1)..letterAt(n)))
  result[0].shuffle()

  for row in 1..(n - 2):
    var ok = false
    while not ok:
      block shuffling:
        result[row].shuffle()
        for prev in 0..<row:
          for col in 0..<n:
            if result[row][col] == result[prev][col]:
              break shuffling
        ok = true

  for col in 0..<n:
    var s = {letterAt(1)..letterAt(n)}
    for row in 0..(n - 2):
      s.excl result[row][col]
    result[^1][col] = s.get()


proc `$`(s: LatinSquare): string =
  let n = s.len
  for row in 0..<n:
    result.add s[row].join(" ") & '\n'


randomize()
echo latinSquare(5)
echo latinSquare(5)
echo latinSquare(10)
