 import strformat, times

func ulam(n: Positive): int =
  if n <= 2: return n
  const Max = 1352000
  var list = newSeq[int](Max)
  list[0] = 1
  list[1] = 2
  var sums = newSeq[byte](2 * Max + 1)
  sums[3] = 1
  var size = 2
  var query: int
  while size < n:
    query = list[size-1] + 1
    while true:
      if sums[query] == 1:
        for i in 0..<size:
          let sum = query + list[i]
          let t = sums[sum] + 1
          if t <= 2: sums[sum] = t
        list[size] = query
        inc size
        break
      inc query
  result = query

let t0 = cpuTime()
var n = 10
while n <= 100_000:
  echo &"The {n}th Ulam number is {ulam(n)}."
  n *= 10
echo &"\nTook {cpuTime() - t0:.3f} s."
