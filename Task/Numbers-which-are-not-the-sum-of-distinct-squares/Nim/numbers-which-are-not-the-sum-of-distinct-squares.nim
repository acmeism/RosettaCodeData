import std/[algorithm, math, monotimes, strformat, strutils, times]

proc soms(n: int; f: seq[int]): bool =
  ## Recursively permutates the list of squares to seek a matching sum.
  if n <= 0: return false
  if n in f: return true
  case cmp(n, sum(f))
  of 1:
    result = false
  of 0:
    result = true
  else:
    let rf = reversed(f.toOpenArray(0, f.len - 2))
    result = soms(n - f[^1], rf) or soms(n, rf)

let start = getMonoTime()
var s, a: seq[int]
var i, g = 1
while g >= i shr 1:
  let r = sqrt(i.toFloat).int
  if r * r == i: s.add i
  if not soms(i, s):
    g = i
    a.add g
  inc i

echo "Numbers which are not the sum of distinct squares:"
echo a.join(" ")
echo &"\nStopped checking after finding {i - g} sequential non-gaps after the final gap of {g}."
echo &"Found {a.len} total in {(getMonotime() - start).inMicroseconds} µs."
