import math, strformat, strutils

iterator sternBrocot(): (int, int) =
  ## Yield index and value of the terms of the sequence.
  var sequence: seq[int]
  sequence.add 1
  sequence.add 1
  var index = 1
  yield (1, 1)
  yield (2, 1)
  while true:
    sequence.add sequence[index] + sequence[index - 1]
    yield (sequence.len, sequence[^1])
    sequence.add sequence[index]
    yield (sequence.len, sequence[^1])
    inc index

# Fiind first 15 terms.
var res: seq[int]
for i, n in sternBrocot():
  res.add n
  if i == 15: break
echo "First 15 terms: ", res.join(" ")
echo()

# Find indexes for 1..10.
var indexes: array[1..10, int]
var toFind = 10
for i, n in sternBrocot():
  if n in 1..10 and indexes[n] == 0:
    indexes[n] = i
    dec toFind
    if toFind == 0: break
for n in 1..10:
  echo &"Index of first occurrence of number {n:3}: {indexes[n]:4}"

# Find index for 100.
var index: int
for i, n in sternBrocot():
  if n == 100:
    index = i
    break
echo &"Index of first occurrence of number 100: {index:4}"
echo()

# Check GCD.
var prev = 1
index = 1
for i, n in sternBrocot():
  if gcd(prev, n) != 1: break
  prev = n
  inc index
  if index > 1000: break
if index <= 1000:
  echo "Found two successive terms at index: ", index
else:
  echo "All consecutive terms up to the 1000th member have a GCD equal to one."
