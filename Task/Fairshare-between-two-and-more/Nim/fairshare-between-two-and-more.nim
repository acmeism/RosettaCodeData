import math, strutils

#---------------------------------------------------------------------------------------------------

iterator countInBase(b: Positive): seq[Natural] =
  ## Yield the successive integers in base "b" as a sequence of digits.

  var value = @[Natural 0]
  yield value

  while true:

    # Add one to current value.
    var c = 1
    for i in countdown(value.high, 0):
      let val = value[i] + c
      if val < b:
        value[i] = val
        c = 0
      else:
        value[i] = val - b
        c = 1

    if c == 1:
      # Add a new digit at the beginning.
      # In this case, for better performances, we could have add it at the end.
      value.insert(c, 0)

    yield value

#---------------------------------------------------------------------------------------------------

func thueMorse(b: Positive; count: Natural): seq[Natural] =
  ## Return the "count" first elements of Thue-Morse sequence for base "b".

  var count = count
  for n in countInBase(b):
    result.add(sum(n) mod b)
    dec count
    if count == 0: break

#———————————————————————————————————————————————————————————————————————————————————————————————————

for base in [2, 3, 5, 11]:
  echo "Base ", ($base & ": ").alignLeft(4), thueMorse(base, 25).join(" ")
