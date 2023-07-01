iterator combinations(m: int, n: int): seq[int] =

  var result = newSeq[int](n)
  var stack = newSeq[int]()
  stack.add 0

  while stack.len > 0:
    var index = stack.high
    var value = stack.pop()

    while value < m:
      result[index] = value
      inc value
      inc index
      stack.add value

      if index == n:
        yield result
        break

for i in combinations(5, 3):
  echo i
