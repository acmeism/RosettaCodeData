# With sorting.
import algorithm, strformat

proc extractAndAddTwoSmallest(list: var seq[int]) =
  list.sort(Descending)
  stdout.write &"Descending sorted list: {list}"
  let min1 = list.pop()
  let min2 = list.pop()
  echo &"; two smallest: {min1} and {min2}; sum = {min1 + min2}"
  list.add min1 + min2

var list = @[6, 81, 243, 14, 25, 49, 123, 69, 11]

while list.len >= 2:
  list.extractAndAddTwoSmallest()
echo &"Last item is {list[0]}."
