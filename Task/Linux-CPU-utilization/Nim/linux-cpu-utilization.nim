import math, sequtils, strutils

let firstLine = "/proc/stat".readLines(1)[0]
let values = firstLine.splitWhitespace()[1..^1].map(parseInt)
let totalTime = sum(values)
let idleFrac = values[3] / totalTime
let notIdlePerc = (1 - idleFrac) * 100
echo "CPU utilization = ", notIdlePerc.formatFloat(ffDecimal, precision = 1), " %"
