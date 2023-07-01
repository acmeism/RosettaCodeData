import math, strutils

var
  prod = 1
  sum = 0

let
  x = +5
  y = -5
  z = -2
  one = 1
  three = 3
  seven = 7

proc body(j: int) =
  sum += abs(j)
  if abs(prod) < 2^27 and j != 0: prod *= j


for j in countup(-three, 3^3, three): body(j)
for j in countup(-seven, seven, x): body(j)
for j in countup(555, 550 - y): body(j)
for j in countdown(22, -28, three): body(j)
for j in countup(1927, 1939): body(j)
for j in countdown(x, y, -z): body(j)
for j in countup(11^x, 11^x + one): body(j)

let s = ($sum).insertSep(',')
let p = ($prod).insertSep(',')
let m = max(s.len, p.len)
echo " sum = ", s.align(m)
echo "prod = ", p.align(m)
