import std/[strformat, tables]

func isPrime(n: Natural): bool =
  ## Return "true" is "n" is prime.
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  var step = 2
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, step
    step = 6 - step
  return true

const Inc = [4, 2, 4, 2, 4, 6, 2, 6]

func firstPrimeFactor(n: Positive): int =
  ## Return the first prime factor.
  ## Assuming "n" is odd.
  if n == 1: return 1
  if n mod 3 == 0: return 3
  if n mod 5 == 0: return 5
  var k = 7
  var i = 0
  while k * k <= n:
    if n mod k == 0:
      return k
    k += Inc[i]
    i = (i + 1) and 7
  return n


var blum: array[50, int]
var bc = 0
var counts: CountTable[int]
var n = 1
while true:
  var p = n.firstPrimeFactor
  if (p and 3) == 3:
    let q = n div p
    if q != p and (q and 3) == 3 and q.isPrime:
      if bc < 50: blum[bc] = n
      counts.inc(n mod 10)
      inc bc
      if bc == 50:
        echo "First 50 Blum integers:"
        for i, val in blum:
          stdout.write &"{val:3}"
          stdout.write if i mod 10 == 9: '\n' else: ' '
        echo()
      elif bc == 26828 or bc mod 100000 == 0:
        echo &"The {bc:>6}th Blum integer is: {n:>7}"
        if bc == 400000:
          echo "\n% distribution of the first 400_000 Blum integers:"
          for i in [1, 3, 7, 9]:
            echo &"  {counts[i]/4000:6.3f} % end in {i}"
          break
  n = if n mod 5 == 3: n + 4 else: n + 2
