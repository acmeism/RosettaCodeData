import os, strutils, sequtils

var
  nodata = 0
  nodataMax = -1
  nodataMaxLine:seq[string] = @[]

  totFile = 0.0
  numFile = 0

for filename in commandLineParams():
  var f = open(filename)
  for line in f.lines:
    var
      totLine = 0.0
      numLine = 0
      field = line.split()
      date = field[0]
      data: seq[float] = @[]
      flags: seq[int] = @[]

    for i, f in field[1 .. -1]:
      if i mod 2 == 0: data.add parseFloat(f)
      else: flags.add parseInt(f)

    for datum, flag in items(zip(data, flags)):
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

    echo "Line: $#  Reject: $#  Accept: $#  LineTot: $# LineAvg: $#"
      .format(date, data.len - numLine, numLine,
              formatFloat(totLine, precision = 0), formatFloat(
        (if numLine > 0: totLine / float(numLine) else: 0.0), precision = 0))

echo ""
echo "File(s)   = ", commandLineParams().join(" ")
echo "Total     = ", formatFloat(totFile, precision = 0)
echo "Readings  = ", numFile
echo "Average   = ", formatFloat(totFile / float(numFile), precision = 0)
echo ""
echo "Maximum run(s) of ", nodataMax, " consecutive false readings ends at line starting with date(s): ", nodataMaxLine.join(" ")
