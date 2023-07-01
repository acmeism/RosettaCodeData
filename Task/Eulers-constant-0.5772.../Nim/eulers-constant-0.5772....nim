import std/math

const n = 1e6
var result = 1.0

for i in 2..int(n):
  result += 1/i

echo result - ln(n)
