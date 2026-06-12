import sequtils, strutils

let lineCount = stdin.readLine.parseInt()
for _ in 1..lineCount:
  let line = stdin.readLine()
  let fields = line.splitWhitespace()
  assert fields.len == 2
  let pair = fields.map(parseInt)
  echo pair[0] + pair[1]
