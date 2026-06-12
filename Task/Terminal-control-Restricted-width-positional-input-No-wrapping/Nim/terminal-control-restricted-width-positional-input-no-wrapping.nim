import strformat, terminal

proc eraseLineEnd() = stdout.write("\e[K")

proc inputXYUpto(row, col, cmax: int; width = cmax): string =
  while result.len < cmax and not ((let c = getch(); c) in ['\xff', '\f', '\r']):
    setCursorPos(row, col)
    eraseLineEnd()
    if c in ['\b', '\x7f'] and result.len > 0:
      result.setLen(result.len - 1)
    else:
      result.add c
    stdout.write result[(if result.len > width: result.len - width else: 0)..result.high]

eraseScreen()
setCursorPos(3, 5)
let s = inputXYUpto(3, 5, 8)
echo &"\n\n\nResult:  You entered <<{s}>>"
