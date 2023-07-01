mode = (arr) ->
  # returns an array with the modes of arr, i.e. the
  # elements that appear most often in arr
  counts = {}
  for elem in arr
    counts[elem] ||= 0
    counts[elem] += 1
  max = 0
  for key, cnt of counts
    max = cnt if cnt > max
  (key for key, cnt of counts when cnt == max)

console.log mode [1, 2, 2, 2, 3, 3, 3, 4, 4]
