import std/[monotimes, strutils, times]

const IsPrime = [false, false, true, true, false, true, false, true,
                 false, false, false, true, false, true, false, false,
                 false, true, false, true, false, false, false, true,
                 false, false, false, false, false, true, false, true,
                 false, false, false, false, false, true, false, false,
                 false, true, false, true, false, false, false, true,
                 false, false, false, false, false, true, false, false,
                 false, false, false, true, false, true, false, false]

type TriangleRow = openArray[Natural]

template isPrime(n: Natural): bool = IsPrime[n]

func primeTriangleRow(a: var TriangleRow): bool =
  if a.len == 2:
    return isPrime(a[0] + a[1])
  for i in countup(1, a.len - 2, 2):
    if isPrime(a[0] + a[i]):
      swap a[i], a[1]
      if primeTriangleRow(a.toOpenArray(1, a.high)):
        return true
      swap a[i], a[1]

func primeTriangleCount(a: var TriangleRow): Natural =
  if a.len == 2:
    if isPrime(a[0] + a[1]):
      inc result
  else:
    for i in countup(1, a.len - 2, 2):
      if isPrime(a[0] + a[i]):
        swap a[i], a[1]
        inc result, primeTriangleCount(a.toOpenArray(1, a.high))
        swap a[i], a[1]

proc print(a: TriangleRow) =
  if a.len == 0: return
  for i, n in a:
    if n > 0: stdout.write ' '
    stdout.write align($n, 2)
  stdout.write '\n'

let start = getMonoTime()
for n in 2..20:
  var a = newSeq[Natural](n)
  for i in 0..<n:
    a[i] = i + 1
  if a.primeTriangleRow:
    print a
echo()
for n in 2..20:
  var a = newSeq[Natural](n)
  for i in 0..<n:
    a[i] = i + 1
  if n > 2: stdout.write " "
  stdout.write a.primeTriangleCount
echo '\n'

echo "Elapsed time: ", (getMonoTime() - start).inMilliseconds, " ms"
