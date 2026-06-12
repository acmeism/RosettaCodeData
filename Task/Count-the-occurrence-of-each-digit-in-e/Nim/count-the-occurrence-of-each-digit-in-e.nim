from strutils import join
import sugar

var
  digitCount = [0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
  maxIdx = 2000
  v: seq[int]

for i in 1..maxIdx:
  v &= 1

for col in 0..<(2 * maxIdx + 1):
  var
    a = maxIdx + 1
    c = 0

  for i in 0..<maxIdx:
    c += v[i] * 10
    v[i] = c mod a
    c = c div a
    a -= 1

  digitCount[c] += 1

var output = collect(newSeq):
  for count in digitCount: $count

echo output.join(" ")
