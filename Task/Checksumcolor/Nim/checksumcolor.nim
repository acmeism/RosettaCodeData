import re, terminal

const Colors = [((15,  0,  0), fgRed),
                (( 0, 15,  0), fgGreen),
                ((15, 15,  0), fgYellow),
                (( 0,  0, 15), fgBlue),
                ((15,  0, 15), fgMagenta),
                (( 0, 15, 15), fgCyan)]

let Re = re"^([A-Fa-f0-9]+)([ \t]+.+)$"

type RGB = tuple[r, g, b: int]

func squareDist(c1, c2: RGB): int =
  let xd = c1.r - c2.r
  let yd = c1.g - c2.g
  let zd = c1.b - c2.b
  result = xd * xd + yd * yd + zd * zd


func intValue(c: char): int =
  case c
  of 'a'..'f': ord(c) - ord('a') + 10
  of 'A'..'F': ord(c) - ord('A') + 10
  of '0'..'9': ord(c) - ord('0')
  else: raise newException(ValueError, "incorrect input")


proc printColor(s: string) =
  var k = 0
  for i in 0..<(s.len div 3):
    let j = i * 3
    let c1 = s[j]
    let c2 = s[j+1]
    let c3 = s[j+2]
    k = j + 3
    let rgb: RGB = (c1.intValue(), c2.intValue(), c3.intValue())
    var m = 676
    var color = fgDefault
    for cex in Colors:
      let sqd = squareDist(cex[0], rgb)
      if sqd < m:
        color = cex[1]
        m = sqd
    stdout.setForegroundColor(color)
    stdout.write c1, c2, c3

  setForegroundColor(fgDefault)
  for j in k..s.high: stdout.write s[j]


proc colorChecksum() =
  for line in stdin.lines:
    var s: array[2, string]
    if line.match(Re, s):
      printColor(s[0])
      echo s[1]
    else:
      echo line

proc cat() =
  for line in stdin.lines: echo line

if stdout.isatty: colorChecksum()
else: cat()
