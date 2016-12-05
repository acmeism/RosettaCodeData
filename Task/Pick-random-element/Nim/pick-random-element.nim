import math
randomize()

proc random[T](a: openarray[T]): T =
  a[random(a.low..a.len)]

let ls = @["foo", "bar", "baz"]
echo ls.random()

var xs: array[10..14, string]
for i in 10..14:
  xs[i] = "foo: " & $i

echo xs.random()
