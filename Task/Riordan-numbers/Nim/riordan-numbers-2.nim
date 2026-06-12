import std/strformat
import integers

iterator riordan(): Integer =
  var prev = newInteger(1)
  var curr = newInteger(0)
  yield prev
  var n = 1
  while true:
    yield curr
    inc n
    let next = (n - 1) * (2 * curr + 3 * prev) div (n + 1)
    prev = curr
    curr = next

var count = 0
for n in riordan():
  inc count
  if count in [1000, 10000]:
    echo &"The {count}th Riordan number has {len($n)} digits."
    if count == 10000: break
