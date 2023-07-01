import os, math, strutils, tables

let execName = getAppFilename().splitPath().tail
let srcName = execName & ".nim"

func entropy(str: string): float =
  var counts: CountTable[char]
  for ch in str:
    counts.inc(ch)
  for count in counts.values:
    result -= count / str.len * log2(count / str.len)

echo "Source file entropy: ", srcName.readFile().entropy().formatFloat(ffDecimal, 5)
echo "Binary file entropy: ", execName.readFile().entropy().formatFloat(ffDecimal, 5)
