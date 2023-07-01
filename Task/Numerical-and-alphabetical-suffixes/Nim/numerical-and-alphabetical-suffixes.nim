import re, strutils, parseutils, tables, math
const input = """
    2greatGRo   24Gros  288Doz  1,728pairs  172.8SCOre
    1,567      +1.567k    0.1567e-2m
    25.123kK    25.123m   2.5123e-00002G
    25.123kiKI  25.123Mi  2.5123e-00002Gi  +.25123E-7Ei
    -.25123e-34Vikki      2e-77gooGols
    9!   9!!   9!!!   9!!!!   9!!!!!   9!!!!!!   9!!!!!!!   9!!!!!!!!   9!!!!!!!!!
    """
let
  abbrAlpha = re(r"(PAIR)(s)?$|(SCO)(r|re|res)?$|(DOZ)(e|en|ens)?$|(GR)(o|os|oss)?$|(GREATGR)(o|os|oss)?$|(GOOGOL)(s)?$",
      flags = {reIgnoreCase})
  metricBinary = re(r"[KMGTPEZYXWVU]i?", flags = {reIgnoreCase})
  factorial = re"!+$"
const
  alphaValues = [2e0, 20e0, 12e0, 144e0, 1728e0, 1e100]
  metricBinaryValueTab = {"K": 10.0^3, "KI": 2.0^10, "M": 10.0^6, "MI": 2.0^20,
      "G": 10.0^9, "GI": 2.0^30, "T": 10.0^12, "TI": 2.0^40, "P": 10.0^15,
      "PI": 2.0^50, "E": 10.0^18, "EI": 2.0^60, "Z": 10.0^21, "ZI": 2.0^70,
      "Y": 10.0^24, "YI": 2.0^80, "X": 10.0^27, "XI": 2.0^90, "W": 10.0^30,
      "WI": 2.0^100, "V": 10.0^33, "VI": 2.0^110, "U": 10.0^36,
      "UI": 2.0^120}.toTable
var
  matches: array[12, string]
  res, fac: float
  suffix: string
proc sepFloat(f: float): string =
  var
    s = $f
    i, num: int
  num = parseInt(s, i)
  if num == 0:
    return s
  else:
    return insertSep($i, ',', 3)&s[num..^1]
for line in input.splitLines():
  if not isEmptyOrWhiteSpace(line):
    echo("Input:\n", line, "\nOutput:")
    var output = "    "
    for raw_number in line.replace(",", "").splitWhiteSpace():
      suffix = raw_number[parseutils.parseFloat(raw_number, res)..^1].toUpper()
      if suffix.match(abbrAlpha, matches):
        for i, v in matches.mpairs():
          if i mod 2 == 0 and not v.isEmptyOrWhiteSpace():
            res*=alphaValues[i div 2]
            v = ""
            break
      elif suffix.match(factorial):
        fac = abs(res)-toFloat(len(suffix))
        while fac > 0:
          res*=fac
          fac-=toFloat(len(suffix))
      elif suffix.match(metricBinary):
        for m in suffix.findAll(metricBinary):
          res*=metricBinaryValueTab[m]
      output &= sepFloat(res)&"  "
    echo(output)
