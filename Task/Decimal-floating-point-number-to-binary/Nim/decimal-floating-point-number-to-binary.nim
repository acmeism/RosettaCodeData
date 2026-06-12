import math, strutils

func decToBin(f: float): string =
  let parts = f.splitDecimal()
  result = int(parts[0]).toBin(64).strip(trailing = false, chars = {'0'}) & '.'
  var d = parts[1]
  while d > 0.0:
    let r = d * 2
    if r >= 1:
      result.add '1'
      d = r - 1
    else:
      result.add '0'
      d = r

func binToDec(s: string): float =
  let num = fromBin[int](s.replace(".", ""))
  let den = fromBin[int]('1' & s.split('.')[1].replace('1', '0'))
  result = num / den

when isMainModule:

  let d = 23.34375
  echo d, "   → ", decToBin(d)
  let s = "1011.11101"
  echo s, " → ", binToDec(s)
