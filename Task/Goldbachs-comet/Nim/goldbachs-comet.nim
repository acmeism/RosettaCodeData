import std/[math, strformat, strutils, sugar]
import chroma, plotly

const
  N1 = 100        # For part 1 of task.
  N2 = 1_000_000  # For part 2 of task.
  N3 = 2000       # For stretch part.

# Erathostenes sieve.
var isPrime: array[1..N1, bool]
for i in 2..N1: isPrime[i] = true
for n in 2..sqrt(N1.toFloat).int:
  for k in countup(n * n, N1, n):
    isPrime[k] = false

proc g(n: int): int =
  ## Goldbach function.
  assert n > 2 and n mod 2 == 0, "“n” must be even and greater than 2."
  for i in 1..(n div 2):
    if isPrime[i] and isPrime[n - i]:
      inc result

# Part 1.
echo &"First {N1} G numbers:"
var col = 1
for n in 2..N1:
  stdout.write align($g( 2 * n), 3)
  stdout.write if col mod 10 == 0: '\n' else: ' '
  inc col

# Part 2.
echo &"\nG({N2}) = ", g(N2)

# Stretch part.

const Colors = collect(for name in ["red", "blue", "green"]: name.parseHtmlName())
var x, y: seq[float]
var colors: seq[Color]
for n in 2..N3:
  x.add n.toFloat
  y.add g(2 * n).toFloat
  colors.add Colors[n mod 3]

let trace = Trace[float](type: Scatter, mode: Markers, marker: Marker[float](color: colors), xs: x, ys: y)
let layout = Layout(title: "Goldbach’s comet", width: 1200, height: 400)
Plot[float64](layout: layout, traces: @[trace]).show(removeTempFile = true)
