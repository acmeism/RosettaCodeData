import random, os, sequtils, strutils

randomize()

type State {.pure.} = enum Empty, Tree, Fire

const
  Disp: array[State, string] = ["  ", "\e[32m/\\\e[m", "\e[07;31m/\\\e[m"]
  TreeProb = 0.01
  BurnProb = 0.001

proc chance(prob: float): bool {.inline.} = rand(1.0) < prob

# Set the size
var w, h: int
if paramCount() >= 2:
  w = paramStr(1).parseInt
  h = paramStr(2).parseInt
if w <= 0: w = 30
if h <= 0: h = 30

iterator fields(a = (0, 0), b = (h-1, w-1)): tuple[y, x: int] =
  ## Iterate over fields in the universe
  for y in max(a[0], 0) .. min(b[0], h-1):
    for x in max(a[1], 0) .. min(b[1], w-1):
      yield (y, x)

# Initialize
var univ, univNew = newSeqWith(h, newSeq[State](w))

while true:

  # Show.
  stdout.write "\e[H"
  for y, x in fields():
    stdout.write Disp[univ[y][x]]
    if x == 0: stdout.write "\e[E"
  stdout.flushFile

  # Evolve.
  for y, x in fields():
    case univ[y][x]
    of Fire:
      univNew[y][x] = Empty
    of Empty:
      if chance(TreeProb): univNew[y][x] = Tree
    of Tree:
      for y1, x1 in fields((y-1, x-1), (y+1, x+1)):
        if univ[y1][x1] == Fire:
          univNew[y][x] = Fire
          break
      if chance(BurnProb): univNew[y][x] = Fire
  univ = univNew
  sleep 200
