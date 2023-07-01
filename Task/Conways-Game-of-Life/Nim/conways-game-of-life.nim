import os, strutils, random

randomize()
var w, h: int
if paramCount() >= 2:
  w = parseInt(paramStr(1))
  h = parseInt(paramStr(2))
if w <= 0: w = 30
if h <= 0: h = 30

# Initialize
var univ, utmp = newSeq[seq[bool]](h)
for y in 0..<h:
  univ[y].newSeq w
  utmp[y].newSeq w
  for x in 0 ..< w:
    if rand(9) < 1:
      univ[y][x] = true

while true:
  # Show
  stdout.write "\e[H"
  for y in 0..<h:
    for x in 0..<w:
      stdout.write if univ[y][x]: "\e[07m  \e[m" else: "  "
    stdout.write "\e[E"
  stdout.flushFile

  # Evolve
  for y in 0..<h:
    for x in 0..<w:
      var n = 0
      for y1 in y-1..y+1:
        for x1 in x-1..x+1:
          if univ[(y1+h) mod h][(x1 + w) mod w]:
            inc n

      if univ[y][x]: dec n
      utmp[y][x] = n == 3 or (n == 2 and univ[y][x])
  swap(univ,utmp)

  sleep 200
