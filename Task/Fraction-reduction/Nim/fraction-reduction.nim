# Fraction reduction.

import strformat
import times

type Result = tuple[n: int, nine: array[1..9, int]]

template find[T; N: static int](a: array[1..N, T]; value: T): int =
  ## Return the one-based index of a value in an array.
  ## This is needed as "system.find" returns a 0-based index even if the
  ## array lower bound is not null.
  system.find(a, value) + 1

func toNumber(digits: seq[int]; removeDigit: int = 0): int =
  ## Convert a list of digits into a number.
  var digits = digits
  if removeDigit != 0:
    let idx = digits.find(removeDigit)
    digits.delete(idx)
  for d in digits:
    result = 10 * result + d

func nDigits(n: int): seq[Result] =
  var digits = newSeq[int](n + 1)   # Allocating one more to work with one-based indexes.
  var used: array[1..9, bool]
  for i in 1..n:
    digits[i] = i
    used[i] = true
  var terminated = false
  while not terminated:
    var nine: array[1..9, int]
    for i in 1..9:
      if used[i]:
        nine[i] = digits.toNumber(i)
    result &= (n: digits.toNumber(), nine: nine)
    block searchLoop:
      terminated = true
      for i in countdown(n, 1):
        let d = digits[i]
        doAssert(used[d], "Encountered an inconsistency with 'used' array")
        used[d] = false
        for j in (d + 1)..9:
          if not used[j]:
            used[j] = true
            digits[i] = j
            for k in (i + 1)..n:
              digits[k] = used.find(false)
              used[digits[k]] = true
            terminated = false
            break searchLoop


let start = gettime()

for n in 2..6:
  let rs = nDigits(n)
  var count = 0
  var omitted: array[1..9, int]
  for i in 1..<rs.high:
    let (xn, rn) = rs[i]
    for j in (i + 1)..rs.high:
      let (xd, rd) = rs[j]
      for k in 1..9:
        let yn = rn[k]
        let yd = rd[k]
        if yn != 0 and yd != 0 and xn * yd == yn * xd:
          inc count
          inc omitted[k]
          if count <= 12:
            echo &"{xn}/{xd} => {yn}/{yd} (removed {k})"

  echo &"{n}-digit fractions found: {count}, omitted {omitted}\n"
echo &"Took {gettime() - start}"
