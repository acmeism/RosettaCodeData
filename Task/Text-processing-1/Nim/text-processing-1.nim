import os, sequtils, strutils, strformat

var
  nodata = 0
  nodataMax = -1
  nodataMaxLine: seq[string]

  totFile = 0.0
  numFile = 0

for filename in commandLineParams():
  for line in filename.lines:
    var
      totLine = 0.0
      numLine = 0
      data: seq[float]
      flags: seq[int]

    let fields = line.split()
    let date = fields[0]

    for i, field in fields[1..^1]:
      if i mod 2 == 0: data.add parseFloat(field)
      else: flags.add parseInt(field)

    for datum, flag in zip(data, flags).items:
      if flag < 1:
        inc nodata
      else:
        if nodataMax == nodata and nodata > 0:
          nodataMaxLine.add date
        if nodataMax < nodata and nodata > 0:
          nodataMax = nodata
          nodataMaxLine = @[date]
        nodata = 0
        totLine += datum
        inc numLine

    totFile += totLine
    numFile += numLine

    let average = if numLine > 0: totLine / float(numLine) else: 0.0
    echo &"Line: {date}  Reject: {data.len - numLine:2}  Accept: {numLine:2}  ",
         &"LineTot: {totLine:6.2f} LineAvg: {average:4.2f}"

echo()
echo &"""File(s)   = {commandLineParams().join(" ")}"""
echo &"Total     = {totFile:.2f}"
echo &"Readings  = {numFile}"
echo &"Average   = {totFile / float(numFile):.2f}"
echo ""
echo &"Maximum run(s) of {nodataMax} consecutive false readings ",
     &"""ends at line starting with date(s): {nodataMaxLine.join(" ")}."""
