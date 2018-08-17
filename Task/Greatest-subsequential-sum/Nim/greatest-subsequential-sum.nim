proc maxsum(s: openArray[int]): int =
  var maxendinghere = 0
  for x in s:
    maxendinghere = max(maxendinghere + x, 0)
    result = max(result, maxendinghere)

echo maxsum(@[-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1])
