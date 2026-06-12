# Without sorting.
import strformat

proc extractAndAddTwoSmallest(list: var seq[int]) =
  var min1, min2 = int.high
  var imin1, imin2 = -1
  for i, val in list:
    if val < min1:
      min2 = min1
      min1 = val
      imin2 = imin1
      imin1 = i
    elif val < min2:
      min2 = val
      imin2 = i
  echo &"List: {list}; two smallest: {min1}@{imin1} and {min2}@{imin2}; sum = {min1 + min2}"
  if imin1 > imin2: swap imin1, imin2   # Make sure "imin2" is the greatest index.
  list.del imin2
  list.del imin1
  list.add min1 + min2

var list = @[6, 81, 243, 14, 25, 49, 123, 69, 11]

while list.len >= 2:
  list.extractAndAddTwoSmallest()
echo &"Last item is {list[0]}."
