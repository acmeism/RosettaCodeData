import rdstdin, sequtils, strutils

const bar = ["\u2581", "\u2582", "\u2583", "\u2584", "\u2585", "\u2586", "\u2587", "\u2588"]
const barcount = float(bar.high)

while true:
  let
    line = readLineFromStdin "Numbers please separated by space/commas: "
    numbers = line.split({' ', ','}).filterIt(it.len != 0).map(parseFloat)
    mn = min(numbers)
    mx = max(numbers)
    extent = mx - mn
  var sparkline = ""
  for n in numbers:
    let i = int((n - mn) / extent * barcount)
    sparkline.add bar[i]
  echo "min: ", mn.formatFloat(precision = 0), "; max: ", mx.formatFloat(precision = -1)
  echo sparkline
