import math, os, strutils
randomize()

type State = enum Empty, Tree, Fire

const
  disp: array[State, string] = ["  ", "\e[32m/\\\e[m", "\e[07;31m/\\\e[m"]
  treeProb = 0.01
  burnProb = 0.001

proc chance(prob: float): bool = random(1.0) < prob

# Set the size
var w, h: int
if paramCount() >= 2:
  w = parseInt paramStr 1
  h = parseInt paramStr 2
if w <= 0: w = 30
if h <= 0: h = 30

# Iterate over fields in the universe
iterator fields(a = (0,0), b = (h-1,w-1)) =
  for y in max(a[0], 0) .. min(b[0], h-1):
    for x in max(a[1], 0) .. min(b[1], w-1):
      yield (y,x)

# Create a sequence with an initializer
proc newSeqWith[T](len: int, init: T): seq[T] =
  result = newSeq[T] len
  for i in 0 .. <len:
    result[i] = init

# Initialize
var univ, univNew = newSeqWith(h, newSeq[State] w)

while true:
  # Show
  stdout.write "\e[H"
  for y,x in fields():
    stdout.write disp[univ[y][x]]
    if x == 0: stdout.write "\e[E"
  stdout.flushFile

  # Evolve
  for y,x in fields():
    case univ[y][x]
    of Fire:
      univNew[y][x] = Empty
    of Empty:
      if chance treeProb: univNew[y][x] = Tree
    of Tree:
      for y1, x1 in fields((y-1,x-1), (y+1,x+1)):
        if univ[y1][x1] == Fire: univNew[y][x] = Fire
      if chance burnProb: univNew[y][x] = Fire
  univ = univNew
  sleep 200
