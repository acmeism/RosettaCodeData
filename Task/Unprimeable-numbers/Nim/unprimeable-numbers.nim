import strutils

const N = 10_000_000

# Erastosthenes sieve.
var composite: array[0..N, bool]  # Defualt is false i.e. composite.
composite[0] = true
composite[1] = true
for n in 2..N:
  if not composite[n]:
    for k in countup(n * n, N, n):
      composite[k] = true

template isPrime(n: int): bool = not composite[n]


proc isUmprimeable(n: Positive): bool =
  if n.isPrime: return false
  var nd = $n
  for i, prevDigit in nd:
    for newDigit in '0'..'9':
      if newDigit != prevDigit:
        nd[i] = newDigit
        if nd.parseInt.isPrime: return false
    nd[i] = prevDigit   # Restore initial digit.
  result = true


echo "First 35 unprimeable numbers:"
var n = 100
var list: seq[int]
while list.len < 35:
  if n.isUmprimeable:
    list.add n
  inc n
echo list.join(" "), '\n'

var count = 0
n = 199
while count != 600:
  inc n
  if n.isUmprimeable: inc count
echo "600th unprimeable number: ", ($n).insertSep(','), '\n'

for d in 0..9:
  var n = 200 + d
  while not n.isUmprimeable:
    inc n, 10
  echo "Lowest unprimeable number ending in ", d, " is ", ($n).insertSep(',')
