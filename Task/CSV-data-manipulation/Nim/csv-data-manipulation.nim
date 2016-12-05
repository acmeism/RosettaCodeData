import strutils, streams

let
  csv = newFileStream("data.csv", fmRead)
  outf = newFileStream("data-out.csv", fmWrite)

var lineNumber = 1

while true:
  if atEnd(csv):
    break
  var line = readLine(csv)

  if lineNumber == 1:
    line.add(",SUM")
  else:
    var tmp = 0
    for n in split(line, ","):
      tmp += parseInt(n)
    line.add(",")
    line.add($tmp)

  outf.writeLn($line)

  inc lineNumber
