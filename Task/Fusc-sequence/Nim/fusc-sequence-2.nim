import deques, strformat


iterator fusc(): int =
  var q = [1].toDeque()
  yield 0
  yield 1

  while true:
    var val = q.popFirst()
    q.addLast(val)
    yield val

    val += q[0]
    q.addLast(val)
    yield val


iterator longestFusc(): tuple[idx, val: int] =
  var sofar = 0
  var i = -1
  for f in fusc():
    inc i
    if f >= sofar:
      yield (i, f)
      sofar = if sofar == 0: 10 else: 10 * sofar


#———————————————————————————————————————————————————————————————————————————————————————————————————

const
  MaxFusc = 61
  LongestCount = 7

echo &"First {MaxFusc}:"
var i = -1
for f in fusc():
  inc i
  stdout.write f
  if i == MaxFusc:
    echo ""
    break
  stdout.write ' '

echo "\nLength records:"
var count = 0
for (i, f) in longestFusc():
  inc count
  echo &"fusc({i}) = {f}"
  if count == LongestCount:
    break
