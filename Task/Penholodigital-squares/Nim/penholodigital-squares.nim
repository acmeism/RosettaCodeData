import std/[algorithm, math, strformat, sugar]

const
  Primes = [1: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
  Digits = "0123456789ABCDEF"

func digits(n, base: Positive): seq[int] =
  ## Return the digits of "n" in given base (least significant
  ## digits first).
  var n = n.Natural
  while n != 0:
    result.add n mod base
    n = n div base

func parseInt(d: openArray[char]; base: Positive): int =
  ## Convert a sequence of characters in given base to an integer.
  for c in d:
    result = result * base + (if c <= '9': ord(c) - ord('0') else: ord(c) - ord('A') + 10)

func toBase(n: Natural; base: Positive): string =
  ## Return the string representation of "n" in given base.
  let d = n.digits(base)
  for i in countdown(d.high, 0):
    result.add Digits[d[i]]

func lastPrimeFactor(n: Positive): int =
  ## Return the last prime factor of "n".
  var n = n
  if (n and 1) == 0:
    result = 2
    while true:
      n = n shr 1
      if (n and 1) != 0: break
  var d = 3
  while d * d <= n:
    if n mod d == 0:
      result = d
      while true:
        n = n div d
        if n mod d != 0: break
    inc d, 2
  if n > result: result = n

for b in 9..16:
  let master = Primes[1..<b]
  var phd: seq[int]
  let digits = Digits[1..<b]
  let min = sqrt(digits.parseInt(b).toFloat).ceil.toInt
  let max = sqrt(digits.reversed.parseInt(b).toFloat).ceil.toInt
  let divider = lastPrimeFactor(b - 1)

  # Build the list of square roots of pendholodigital squares.
  for i in min..max:
    if i mod divider != 0: continue
    let sq = i * i
    let digs = sq.digits(b)
    if 0 in digs: continue
    var key = collect(for dig in digs: Primes[dig])
    if sorted(key) == master: phd.add i

  echo &"There is a total of {phd.len} penholodigital squares in base {b}:"
  if b > 13: phd = @[phd[0], phd[^1]]
  for i in 0..phd.high:
    stdout.write &"  {phd[i].toBase(b)}² = {(phd[i]^2).toBase(b)}"
    if i mod 3 == 2: echo()
  if phd.len mod 3 != 0: echo()
  echo()
