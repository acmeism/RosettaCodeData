import std/math

func isGiuga(m: Natural): bool =
  var n = m
  var f = 2
  var l = int(sqrt(n.toFloat))
  while true:
    if n mod f == 0:
      if (m div f - 1) mod f != 0:
        return false
      n = n div f
      if f > n:
        return true
    else:
      inc f
      if f > l:
        return false

var n = 3
var c = 0
const Limit = 4
stdout.write "The first ", Limit, " Giuga numbers are: "
while true:
  if n.isGiuga:
    inc c
    stdout.write n, " "
    if c == Limit: break
  inc n
echo()
