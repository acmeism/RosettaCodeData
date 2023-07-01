proc slice[T](iter: iterator(): T {.closure.}; sl: Slice[T]): seq[T] =
  var i = 0
  for n in iter():
    if i > sl.b: break
    if i >= sl.a: result.add(n)
    inc i

iterator harshad(): int {.closure.} =
  for n in 1 ..<  int.high:
    var sum = 0
    for ch in $n:
      sum += ord(ch) - ord('0')
    if n mod sum == 0:
      yield n

echo harshad.slice 0 ..< 20

for n in harshad():
  if n > 1000:
    echo n
    break
