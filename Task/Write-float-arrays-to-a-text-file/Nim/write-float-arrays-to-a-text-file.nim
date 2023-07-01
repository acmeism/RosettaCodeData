import strutils, math, sequtils

const OutFileName = "floatarr2file.txt"

const
   XPrecision = 3
   Yprecision = 5

let a = [1.0, 2.0, 3.0, 100_000_000_000.0]
let b = [sqrt(a[0]), sqrt(a[1]), sqrt(a[2]), sqrt(a[3])]
var res = ""
for t in zip(a, b):
    res.add formatFloat(t[0], ffDefault, Xprecision) & "    " &
            formatFloat(t[1], ffDefault, Yprecision) & "\n"

OutFileName.writeFile res
var res2 = OutFileName.readFile()
echo res2
