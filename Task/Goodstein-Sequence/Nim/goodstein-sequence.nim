import std/[math, strformat, strutils]

proc bump(n, b: int): int =
  var n = n
  var r: int
  var i = 0
  while n > 0:
    (n, r) = divmod(n, b)
    if r != 0:
      result += r * (b + 1) ^ bump(i, b)
    inc i

proc goodstein(n: int; maxTerms = 10): seq[int] =
  result.add n
  var current = n
  var term = 1
  while term < maxTerms and current != 0:
    current = bump(current, term + 1) - 1
    result.add current
    inc term


when isMainModule:

  echo "Goodstein(n) sequence (first 10) for values of n from 0 through 7:"
  for n in 0..7:
    echo &"Goodstein of {n}: {goodstein(n).join(\", \")}"

  echo "\nThe Nth term of Goodstein(N) sequence counting from 0, for values of N from 0 through 10:"
  for n in 0..10:
    let list = goodstein(n, n + 1)
    echo &"Term {n} of Goodstein({n}): {list[n]}"
