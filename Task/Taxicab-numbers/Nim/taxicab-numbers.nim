import heapqueue, strformat

type

  CubeSum = tuple[x, y, value: int]

# Comparison function needed for the heap queues.
proc `<`(c1, c2: CubeSum): bool = c1.value < c2.value

template cube(n: int): int = n * n * n


iterator cubesum(): CubeSum =
  var queue: HeapQueue[CubeSum]
  var n = 1
  while true:
    while queue.len == 0 or queue[0].value > cube(n):
      queue.push (n, 1, cube(n) + 1)
      inc n
    var s = queue.pop()
    yield s
    inc s.y
    if s.y < s.x: queue.push (s.x, s.y, cube(s.x) + cube(s.y))


iterator taxis(): seq[CubeSum] =
  var result: seq[CubeSum] = @[(0, 0, 0)]
  for s in cubesum():
    if s.value == result[^1].value:
      result.add s
    else:
      if result.len > 1: yield result
      result.setLen(0)
      result.add s      # These two statements are faster than the single result = @[s].


var n = 0
for t in taxis():
  inc n
  if n > 2006: break
  if n <= 25 or n >= 2000:
    stdout.write &"{n:4}: {t[0].value:10}"
    for s in t:
      stdout.write &" = {s.x:4}^3 + {s.y:4}^3"
    echo()
