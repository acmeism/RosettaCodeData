data = .array~of(1, 3, 5, 7, 9, 11)
-- search keys with a number of edge cases
searchkeys = .array~of(0, 1, 4, 7, 11, 12)
say "recursive binary search"
loop key over searchkeys
    pos = recursiveBinarySearch(data, key)
    if pos == 0 then say "Key" key "not found"
    else say "Key" key "found at postion" pos
end
say
say "iterative binary search"
loop key over searchkeys
    pos = iterativeBinarySearch(data, key)
    if pos == 0 then say "Key" key "not found"
    else say "Key" key "found at postion" pos
end

::routine recursiveBinarySearch
  -- NB:  Rexx arrays are 1-based
  use strict arg data, value, low = 1, high = (data~items)

  -- make sure we don't go beyond the bounds
  high = min(high, data~items)
  -- zero indicates not found
  if high < low then return 0

  mid = (low + high) % 2
  if data[mid] > value then
      return recursiveBinarySearch(data, value, low, mid - 1)
  else if data[mid] < value then
      return recursiveBinarySearch(data, value, mid + 1, high)
  -- got it!
  return mid

::routine iterativeBinarySearch
  -- NB:  Rexx arrays are 1-based
  use strict arg data, value, low = 1, high = (data~items)

  -- make sure we don't go beyond the bounds
  high = min(high, data~items)
  -- zero indicates not found
  if high < low then return 0
  loop while low <= high
      mid = (low + high) % 2
      if data[mid] > value then
          high = mid - 1
      else if data[mid] < value then
          low = mid + 1
      else
          return mid
  end
  return 0
