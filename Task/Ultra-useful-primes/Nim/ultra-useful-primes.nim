import std/strformat
import integers

let One = newInteger(1)

echo " n  k"
var count = 1
var n = 1
while count <= 13:
  var k = 1
  var p = One shl (1 shl n) - k
  while not p.isPrime:
    p -= 2
    k += 2
  echo &"{n:2}  {k}"
  inc n
  inc count
