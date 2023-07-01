import std/strformat

func status(n: int): tuple[isArithmetic, isComposite: bool] =
  ## Return the status of "n", i.e. whether it is an arithmetic number
  ## and whether it is composite.
  var count = 0
  var sum = 0
  for d in 1..n:
    let q = n div d
    if q < d: break
    if n mod d == 0:
      sum += d
      inc count
      if q != d:
        sum += q
        inc count
  result = (isArithmetic: sum mod count == 0, isComposite: count > 2)

iterator arithmeticNumbers(): tuple[val: int, isComposite: bool] =
  ## Yield the successive arithmetic numbers with their composite status.
  var n = 1
  while true:
    let status = n.status
    if status.isArithmetic:
      yield (n, status.isComposite)
    inc n

echo "First 100 arithmetic numbers:"
var arithmeticCount, compositeCount = 0
for (n, isComposite) in arithmeticNumbers():
  inc arithmeticCount
  inc compositeCount, ord(isComposite)
  if arithmeticCount <= 100:
    stdout.write &"{n:>3}"
    stdout.write if arithmeticCount mod 10 == 0: '\n' else: ' '
  elif arithmeticCount in [1_000, 10_000, 100_000, 1_000_000]:
    echo &"\n{arithmeticCount}th arithmetic number: {n}"
    echo &"Number of composite arithmetic numbers ⩽ {n}: {compositeCount}"
    if arithmeticCount == 1_000_000: break
