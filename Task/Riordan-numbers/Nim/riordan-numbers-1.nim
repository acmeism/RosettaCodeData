import std/strformat

iterator riordan(): int =
  var prev = 1
  var curr = 0
  yield prev
  var n = 1
  while true:
    yield curr
    inc n
    let next = (n - 1) * (2 * curr + 3 * prev) div (n + 1)
    prev = curr
    curr = next

echo &"First 32 Riordan numbers:"
var count = 0
for n in riordan():
  inc count
  stdout.write &"{n:<13}"
  stdout.write if count mod 4 == 0: '\n' else: ' '
  if count == 32: break
