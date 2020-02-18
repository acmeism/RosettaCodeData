import strutils, math, sequtils

const
   outFileName = "floatarr2file.txt"

const
   xprecision = 3
   yprecision = 5

var a: seq[float] = @[1.0, 2.0, 3.0, 100_000_000_000.0]
var b: seq[float] = @[sqrt(a[0]), sqrt(a[1]), sqrt(a[2]), sqrt(a[3])]
var c = zip(a, b)
var res: string = ""
for t in c:
    res.add(formatFloat(t.a, ffDefault, xprecision) & "\t" & formatFloat(t.b, ffDefault, yprecision) & "\n")

writeFile(outFileName, res)
var res2 = readFile(outFileName)
echo(res2)
