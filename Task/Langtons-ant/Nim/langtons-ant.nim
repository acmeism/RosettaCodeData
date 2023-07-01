import strutils, sequtils

type
  Direction = enum up, right, down, left
  Color = enum white, black

const
  width = 75
  height = 52
  maxSteps = 12_000

var
  m: array[height, array[width, Color]]
  dir = up
  x = width div 2
  y = height div 2

var i = 0
while i < maxSteps and x in 0 ..< width and y in 0 ..< height:
  let turn = m[y][x] == black
  m[y][x] = if m[y][x] == black: white else: black

  dir = Direction((4 + int(dir) + (if turn: 1 else: -1)) mod 4)
  case dir
  of up:    dec y
  of right: dec x
  of down:  inc y
  of left:  inc x

  inc i

for row in m:
  echo map(row, proc(x: Color): string =
    if x == white: "." else: "#").join("")
