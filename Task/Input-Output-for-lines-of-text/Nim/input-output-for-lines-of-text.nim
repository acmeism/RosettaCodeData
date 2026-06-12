import strutils

proc write(line: string) =
  echo line

let lineCount = stdin.readLine.parseInt()
for _ in 1..lineCount:
  let line = stdin.readLine()
  line.write()
