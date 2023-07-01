import strutils

const
  Width = 81
  Height = 5

var lines: array[Height, string]
for line in lines.mitems: line = repeat('*', Width)

proc cantor(start, length, index: Natural) =
  let seg = length div 3
  if seg == 0: return
  for i in index..<Height:
    for j in (start + seg)..<(start + seg * 2):
      lines[i][j] = ' '
  cantor(start, seg, index + 1)
  cantor(start + seg * 2, seg, index + 1)

cantor(0, Width, 1)
for line in lines:
  echo line
