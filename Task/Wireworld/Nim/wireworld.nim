import strutils, os

var world, world2 = """
+-----------+
|tH.........|
|.   .      |
|   ...     |
|.   .      |
|Ht.. ......|
+-----------+"""

let h = world.splitLines.len
let w = world.splitLines[0].len

template isH(x, y): int = int(s[i + w * y + x] == 'H')

proc next(o: var string, s: string, w: int) =
  for i, c in s:
    o[i] = case c
      of ' ': ' '
      of 't': '.'
      of 'H': 't'
      of '.':
        if (isH(-1, -1) + isH(0, -1) + isH(1, -1) +
            isH(-1,  0)              + isH(1,  0) +
            isH(-1,  1) + isH(0,  1) + isH(1,  1)
           ) in 1..2: 'H' else: '.'
      else: c

while true:
  echo world
  stdout.write "\x1b[",h,"A"
  stdout.write "\x1b[",w,"D"
  sleep 100

  world2.next(world, w)
  swap world, world2
