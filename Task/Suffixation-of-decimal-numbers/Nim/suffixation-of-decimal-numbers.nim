import math, strutils

const
  Suffixes = ["", "K", "M", "G", "T", "P", "E", "Z", "Y", "X", "W", "V", "U", "googol"]
  None = -1

proc suffize(num: string; digits = None; base = 10): string =

  let exponentDist = if base == 2: 10 else: 3
  let num = num.strip().replace(",", "")
  let numSign = if num[0] in {'+', '-'}: $num[0] else: ""

  var n = abs(num.parseFloat())
  var suffixIndex: int
  if base == 10 and n >= 1e100:
    suffixIndex = 13
    n /= 1e100
  elif n > 1:
    let magnitude = log(n, base.toFloat).int
    suffixIndex = min(magnitude div exponentDist, 12)
    n /= float(base ^ (exponentDist * suffixIndex))
  else:
    suffixIndex = 0

  let numStr = if digits > 0:
                 n.formatFloat(ffDecimal, precision = digits)
               elif digits == 0:
                 # Can’t use "formatFloat" with precision = 0 as it keeps the decimal point.
                 # So convert to nearest int and format this value.
                 $(n.toInt)
               else:
                 n.formatFloat(ffDecimal, precision = 3).strip(chars = {'0'}).strip(chars = {'.'})
  result = numSign & numStr & Suffixes[suffixIndex] & (if base == 2: "i" else: "")


when isMainModule:

  echo "[87,654,321]: ",
       suffize("87,654,321")
  echo "[-998,877,665,544,332,211,000 / digits = 3]: ",
       suffize("-998,877,665,544,332,211,000", 3)
  echo "[+112,233 / digits = 0]: ",
       suffize("+112,233", 0)
  echo "[16,777,216 / digits = 1]: ",
       suffize("16,777,216", 1)
  echo "[456,789,100,000,000 / digits = 2]: ",
       suffize("456,789,100,000,000", 2)
  echo "[456,789,100,000,000 / digits = 2 / base = 10]: ",
       suffize("456,789,100,000,000", 2, 10)
  echo "[456,789,100,000,000 / digits = 5 / base = 2]: ",
       suffize("456,789,100,000,000", digits = 5, base = 2)
  echo "[456,789,100,000.000e+000 / digits = 0 / base = 10]: ",
       suffize("456,789,100,000.000e+000", digits = 0, base = 10)
  echo "[+16777216 / base = 2]: ",
       suffize("+16777216", base = 2)
  echo "[1.2e101]: ",
       suffize("1.2e101")
