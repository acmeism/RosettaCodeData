import os, strutils, sequtils, tables

const Unit2Mult = {"arshin": 0.7112, "centimeter": 0.01,     "diuym":   0.0254,
                   "fut":    0.3048, "kilometer":  1000.0,   "liniya":  0.00254,
                   "meter":  1.0,    "milia":      7467.6,   "piad":    0.1778,
                   "sazhen": 2.1336, "tochka":     0.000254, "vershok": 0.04445,
                   "versta": 1066.8}.toOrderedTable

if paramCount() != 2:
  raise newException(ValueError, "need two arguments: number then units.")

let value = try: parseFloat(paramStr(1))
            except ValueError:
              raise newException(ValueError, "first argument must be a (float) number.")

let unit = paramStr(2)
if unit notin Unit2Mult:
  raise newException(ValueError,
                     "only know the following units: " & toSeq(Unit2Mult.keys).join(" "))

echo value, ' ', unit, " to:"
for (key, mult) in Unit2Mult.pairs:
  echo key.align(10), ": ", formatFloat(value * Unit2Mult[unit] / mult, ffDecimal, 5)
