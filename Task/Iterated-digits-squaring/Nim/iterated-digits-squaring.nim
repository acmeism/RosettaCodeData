import tables

iterator digits(n: int): int =
  ## Yield the digits starting from the unit.
  var n = n
  while true:
    yield n mod 10
    n = n div 10
    if n == 0:
      break


func gen(n: int): int =
  ## Compute the chain.
  result = n
  while result notin [1, 89]:
    var s = 0
    for d in digits(result):
      inc s, d * d
    result = s


func chainsEndingWith89(ndigits: Natural): Natural =
  ## Compute the number of chains ending with 89.

  # Initialize the count table with values for one digit numbers.
  var prevCount, currcount: CountTable[int]
  for i in 0..9: prevcount[i * i] = 1

  # Add next digits.
  for _ in 2..ndigits:
    # Create the next generation count array.
    currcount.clear()
    for val, count in prevcount:
      for newdigit in 0..9:
        # As 0 is included, "currcount" includes "prevcount".
        currcount.inc(newdigit * newdigit + val, count)
    prevcount = currcount

  for val, count in currcount:
    if val != 0 and gen(val) == 89:
      inc result, count

echo "For  8 digits: ", chainsEndingWith89(8)
echo "For 50 digits: ", chainsEndingWith89(15)
