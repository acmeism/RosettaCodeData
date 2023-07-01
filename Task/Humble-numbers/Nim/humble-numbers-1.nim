import sets, strformat


proc min[T](s: HashSet[T]): T =
  ## Return the minimal value in a set.
  if s.card == 0:
    raise newException(ValueError, "set is empty.")
  result = T.high
  for n in s:
    if n < result: result = n


iterator humbleNumbers(): Positive =
  ## Yield the successive humble numbers.
  var s = [1].toHashSet()
  while true:
    let m = min(s)
    yield m
    s.excl(m)
    for k in [2, 3, 5, 7]: s.incl(k * m)


proc showHumbleNumbers(maxCount: Positive) =
  ## Show the first "maxCount" humble numbers.
  var currCount = 0
  for n in humbleNumbers():
    stdout.write n
    inc currCount
    if currCount == maxCount: break
    stdout.write ' '
  echo ""


proc showHumbleCount(ndigits: Positive) =
  ## Show the number of humble numbers with "n <= ndigits" digits.
  echo "Digits   Count"
  echo "------   -----"
  var currdigits = 1
  var count = 0
  var next = 10   # First number with "currdigits + 1" digits.
  for n in humbleNumbers():
    if n >= next:
      # Number of digits has changed.
      echo &"  {currdigits:2d}     {count:5d}"
      inc currdigits
      if currdigits > ndigits: break
      next *= 10
      count = 1
    else:
      inc count


when isMainModule:
  echo "First 50 humble numbers:"
  showHumbleNumbers(50)
  echo ""
  echo "Count of humble numbers with n digits:"
  showHumbleCount(18)
