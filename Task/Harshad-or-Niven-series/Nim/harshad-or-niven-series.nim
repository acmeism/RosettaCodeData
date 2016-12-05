import strutils

proc slice[T](iter: iterator(): T {.closure.}, sl): seq[T] =
  var result {.gensym.}: seq[int64] = @[]
  var i = 0
  for n in iter():
    if i > sl.b:
      break
    if i >= sl.a:
      result.add(n)
    inc i
  result

iterator harshad(): int64 {.closure.} =
  for n in 1 .. < int64.high:
    var sum = 0
    for ch in string($n):
      sum += parseInt("" & ch)
    if n mod sum == 0:
      yield n

echo harshad.slice 0 .. <20

for n in harshad():
  if n > 1000:
    echo n
    break
