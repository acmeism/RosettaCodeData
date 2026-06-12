import random

randomize()

proc generate(s: Slice[int]): seq[int] =
  assert s.a <= s.b
  var count = s.b - s.a + 1
  var generated = newSeq[bool](count) # Initialized to false.
  while count != 0:
    let n = rand(s)
    if not generated[n - s.a]:
      generated[n - s.a] = true
      result.add n
      dec count

for i in 1..5:
  echo generate(1..20)
