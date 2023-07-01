import strutils, times

const Ranges = [0..0, 101..909, 11011..99099, 1110111..9990999, 111101111..999909999]


func isCyclops(d: string): bool =
  d[d.len shr 1] == '0' and d.count('0') == 1

func isPrime(n: Natural): bool =
  if n < 2: return
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  return true

func isBlind(d: string): bool =
  var d = d
  let m = d.len shr 1
  result = (d[0..m-1] & d[m+1..^1]).parseInt().isPrime

func isPalindromic(d: string): bool =
  for i in 1..d.len:
    if d[i-1] != d[^i]: return
  result = true


iterator cyclops(): (int, int) =
  var count = 0
  for r in Ranges:
    for n in r:
      if ($n).isCyclops:
        inc count
        yield (count, n)

iterator primeCyclops(): (int, int) =
  var count = 0
  for (_, n) in cyclops():
    if n.isPrime:
      inc count
      yield (count, n)

iterator blindPrimeCyclops(): (int, int) =
  var count = 0
  for (_, n) in primeCyclops():
    if ($n).isBlind:
      inc count
      yield (count, n)

iterator palindromicPrimeCyclops(): (int, int) =
  var count = 0
  for r in Ranges:
    for n in r:
      let d = $n
      if d.isCyclops and d.isPalindromic and n.isPrime:
        inc count
        yield (count, n)

let t0 = cpuTime()

echo "List of first 50 cyclops numbers:"
for i, n in cyclops():
  stdout.write ($n).align(3), if i mod 10 == 0: '\n' else: ' '
  if i == 50: break

echo "\nList of first 50 prime cyclops numbers:"
for i, n in primeCyclops():
  stdout.write ($n).align(5), if i mod 10 == 0: '\n' else: ' '
  if i == 50: break

echo "\nList of first 50 blind prime cyclops numbers:"
for i, n in blindPrimeCyclops():
  stdout.write ($n).align(5), if i mod 10 == 0: '\n' else: ' '
  if i == 50: break

echo "\nList of first 50 palindromic prime cyclops numbers:"
for i, n in palindromicPrimeCyclops():
  stdout.write ($n).align(7), if i mod 10 == 0: '\n' else: ' '
  if i == 50: break

for i, n in cyclops():
  if n > 10_000_000:
    echo "\nFirst cyclops number greater than ten million is ",
         ($n).insertSep(), " at 1-based index: ", i
    break

for i, n in primeCyclops():
  if n > 10_000_000:
    echo "\nFirst prime cyclops number greater than ten million is ",
         ($n).insertSep(), " at 1-based index: ", i
    break

for i, n in blindPrimeCyclops():
  if n > 10_000_000:
    echo "\nFirst blind prime cyclops number greater than ten million is ",
         ($n).insertSep(), " at 1-based index: ", i
    break

for i, n in palindromicPrimeCyclops():
  if n > 10_000_000:
    echo "\nFirst palindromic prime cyclops number greater than ten million is ",
         ($n).insertSep(), " at 1-based index: ", i
    break

echo "\nExecution time: ", (cpuTime() - t0).formatFloat(ffDecimal, precision = 3), " seconds."
