import std/strformat

func pow(a, n: Natural; m: Positive): Natural =
  var a = a mod m
  var n = n
  if a > 0:
    result = 1
    while n > 0:
      if (n and 1) != 0:
        result = (result * a) mod m
      n = n shr 1
      a = (a * a) mod m

iterator curzonNumbers(k: Positive): Natural =
  assert (k and 1) == 0, "base must be even."
  var n = 1
  while true:
    let m = k * n + 1
    if pow(k, n, m) + 1 == m:
      yield n
    inc n

### Task ###
for k in countup(2, 10, 2):
  echo &"Curzon numbers for k = {k}:"
  var count = 0
  for n in curzonNumbers(k):
    inc count
    stdout.write &"{n:>4}"
    stdout.write if count mod 10 == 0: '\n' else: ' '
    if count == 50: break
  echo()

### Stretch task ###
for k in countup(2, 10, 2):
  var count = 0
  for n in curzonNumbers(k):
    inc count
    if count == 1000:
      echo &"1000th Curzon number for k = {k:>2}: {n:>5}"
      break
