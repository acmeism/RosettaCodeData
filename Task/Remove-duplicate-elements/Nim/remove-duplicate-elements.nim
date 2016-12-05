import sequtils, algorithm, intsets

# Go through the list, and for each element, check the rest of the list to see
# if it appears again,
var items = @[1, 2, 3, 2, 3, 4, 5, 6, 7]
echo deduplicate(items) # O(n^2)

proc filterDup(xs): seq[int] =
  result = @[xs[0]]
  var last = xs[0]
  for x in xs[1..xs.high]:
    if x != last:
      result.add(x)
      last = x

#  Put the elements into a hash table which does not allow duplicates.
var s = initIntSet()
for x in items:
  s.incl(x)
echo s

# Sort the elements and remove consecutive duplicate elements.
sort(items, system.cmp[int]) # O(n log n)
echo filterDup(items) # O(n)
