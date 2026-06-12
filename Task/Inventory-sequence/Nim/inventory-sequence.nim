import std/[strformat, tables]
import gnuplot

iterator inventorySequence(): (int, int) =
  var counts: CountTable[int]
  var idx = -1
  while true:
    var i = 0
    while true:
      let n = counts[i]
      inc idx
      counts.inc(n)
      yield (idx, n)
      if n == 0: break
      inc i

echo "First 100 elements:"
var x, y: seq[int]
var lim = 1000
for idx, n in inventorySequence():
  if idx < 10000:
    x.add idx
    y.add n
  if idx <= 100:
    stdout.write &"{n:>2}"
    stdout.write if idx mod 10 == 0: '\n' else: ' '
    if idx == 100: echo()
  elif n >= lim:
    echo &"First element ⩾ {lim:>5} is {n:>5} at index {idx:>6}"
    lim += 1000
    if lim > 10000: break

withGnuPlot:
  plot(x, y, "Inventory sequence", "with impulses lw 0.5")
  png("inventory_sequence.png")
