from math import sqrt
import strformat
import strutils

const Tolerance = 1e-10

proc `~=`(a, b: float): bool =
  ## Check if "a" and "b" are close.
  ## We use a relative tolerance to compare the values.
  result = abs(a - b) < max(abs(a), abs(b)) * Tolerance

proc compare(a, b: string) =
  ## Compare "a" and "b" transmitted as strings.
  ## Values are computed using "parseFloat".
  let r = a.parseFloat() ~= b.parseFloat()
  echo fmt"{a} ~= {b} is {r}"

proc compare(a: string; avalue: float; b: string) =
  ## Compare "a" and "b" transmitted as strings.
  ## The value of "a" is transmitted and not computed.
  let r = avalue ~= b.parseFloat()
  echo fmt"{a} ~= {b} is {r}"


compare("100000000000000.01", "100000000000000.011")
compare("100.01", "100.011")
compare("10000000000000.001 / 10000.0", 10000000000000.001 / 10000.0, "1000000000.0000001000")
compare("0.001", "0.0010000001")
compare("0.000000000000000000000101", "0.0")
compare("sqrt(2) * sqrt(2)", sqrt(2.0) * sqrt(2.0), "2.0")
compare("-sqrt(2) * sqrt(2)", -sqrt(2.0) * sqrt(2.0), "-2.0")
compare("3.14159265358979323846", "3.14159265358979324")
