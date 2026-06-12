import random

proc sattoloCycle[T](a: var openArray[T]) =
  for i in countdown(a.high, 1):
    let j = rand(int.high) mod i
    swap a[j], a[i]

var a: seq[int] = @[]
var b: seq[int] = @[10]
var c: seq[int] = @[10, 20]
var d: seq[int] = @[10, 20, 30]
var e: seq[int] = @[11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]

randomize()

a.sattoloCycle()
echo "Shuffled a = ", $a

b.sattoloCycle()
echo "\nShuffled b = ", $b

c.sattoloCycle()
echo "\nShuffled c = ", $c

d.sattoloCycle()
echo "\nShuffled d = ", $d

e.sattoloCycle()
echo "\nShuffled e = ", $e
