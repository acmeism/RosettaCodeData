import algorithm, math, sets, strformat, strutils

#---------------------------------------------------------------------------------------------------

iterator ekg(n, limit: Positive): (int, int) =
  var values: HashSet[int]
  doAssert n >= 2
  yield (1, 1)
  yield (2, n)
  values.incl(n)
  var i = 3
  var prev = n
  while i <= limit:
    var val = 2
    while true:
      if val notin values and gcd(val, prev) != 1:
        values.incl(val)
        yield (i, val)
        prev = val
        break
      inc val
    inc i

#---------------------------------------------------------------------------------------------------

for n in [2, 5, 7, 9, 10]:
  var result: array[1..10, int]
  for i, val in ekg(n, 10): result[i] = val
  let title = fmt"EKG({n}):"
  echo fmt"{title:8} {result.join("", "")}"

var ekg5, ekg7: array[1..100, int]
for i, val in ekg(5, 100): ekg5[i] = val
for i, val in ekg(7, 100): ekg7[i] = val
var convIndex = 0
for i in 2..100:
  if ekg5[i] == ekg7[i] and sorted(ekg5[1..<i]) == sorted(ekg7[1..<i]):
    convIndex = i
    break
if convIndex > 0:
  echo fmt"EKG(5) and EKG(7) converge at index {convIndex}."
else:
  echo "No convergence found in the first {convIndex} terms."
