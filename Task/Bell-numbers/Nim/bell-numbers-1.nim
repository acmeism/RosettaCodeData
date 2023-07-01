import math

iterator b(): int =
  ## Iterator yielding the bell numbers.
  var numbers = @[1]
  yield 1
  var n = 0
  while true:
    var next = 0
    for k in 0..n:
      next += binom(n, k) * numbers[k]
    numbers.add(next)
    yield next
    inc n

when isMainModule:

  import strformat

  const Limit = 25      # Maximum index beyond which an overflow occurs.

  echo "Bell numbers from B0 to B25:"
  var i = 0
  for n in b():
    echo fmt"{i:2d}: {n:>20d}"
    inc i
    if i > Limit:
      break
