import std/[strformat, strutils, tables]

const
  FirstFirst = "zottffssente"   # First letter from 0 to 11.
  FirstLast = "oeoerexntenne"   # Last letter from 0 to 12.

proc firstLetter(n: Natural): char =
  ## Return the first letter of English name for "n".
  const Dividers = [1_000_000, 1_000, 100]
  var n = n
  for d in Dividers:
    if n >= d: n = n div d
  if n in 20..99:
    n = n div 10
  elif n in 12..19:
    n -= 10
  result = FirstFirst[n]

proc lastLetter(n: Natural): char =
  ## Return the last letter of English name for "n".
  const Dividers = [(1_000_000, 'n'), (1_000, 'd'), (100, 'd')]
  var n = n
  for (d, last) in Dividers:
    if n >= d:
      n = n mod d
      if n == 0: return last
  if n >= 20:
    n = n mod 10
    if n == 0: return 'y'
  if n >= 13: return 'n'
  result = FirstLast[n]


# Table to count occurrences of digits.
type Counts = CountTable[range[0..9]]

proc printHistogram(counts: Counts; width: Positive) =
  ## Print histogram of occurrences of last digit.
  const HistBlock = "▆"
  echo "Breakdown by final digit of the numbers:"
  let m = counts.largest[1]
  for d in 0..9:
    let n = counts[d]
    let k = toInt(n * width / m)
    echo &"{d}: {repeat(HistBlock, k)}{repeat(' ', width - k)}  {n}"


var counts: Counts
var n = -1
var count = 0
echo "First 50 qualifying numbers:"
while true:
  inc n
  let last = lastLetter(n)
  let first = firstLetter(n + 1)
  if last == first:
    inc count
    counts.inc (n mod 10)
    if count <= 50:
      stdout.write align($n, 5)
      if count mod 10 == 0: echo()
    elif count in [1_000, 10_000, 100_000, 1_000_000]:
      echo &"\nThe {count}th qualifying number is {insertSep($n)}"
      printHistogram(counts, 60)
      if count == 1_000_000: break
