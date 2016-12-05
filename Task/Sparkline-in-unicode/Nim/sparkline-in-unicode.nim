import rdstdin, strutils, unicode

const bar = [9601, 9602, 9603, 9604, 9605, 9606, 9607, 9608]
const barcount = float(bar.high)

while True:
  let
    line = readLineFromStdin "Numbers please separated by space/commas: "
    numbers = line.split({' ',','}).map(parseFloat)
    mn = min(numbers)
    mx = max(numbers)
    extent = mx - mn
  var sparkline = ""
  for n in numbers:
    let i = int((n-mn) / extent * barcount)
    sparkline.add($TRune(bar[i]))
  echo "min: ", mn.formatFloat(precision = 0), "; max: ", mx.formatFloat(precision = 0)
  echo sparkline
