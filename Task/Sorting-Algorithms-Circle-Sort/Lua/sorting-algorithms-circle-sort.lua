-- Perform one iteration of a circle sort
function innerCircle (t, lo, hi, swaps)
  if lo == hi then return swaps end
  local high, low, mid = hi, lo, math.floor((hi - lo) / 2)
  while lo < hi do
    if t[lo] > t[hi] then
      t[lo], t[hi] = t[hi], t[lo]
      swaps = swaps + 1
    end
    lo = lo + 1
    hi = hi - 1
  end
  if lo == hi then
    if t[lo] > t[hi + 1] then
      t[lo], t[hi + 1] = t[hi + 1], t[lo]
      swaps = swaps + 1
    end
  end
  swaps = innerCircle(t, low, low + mid, swaps)
  swaps = innerCircle(t, low + mid + 1, high, swaps)
  return swaps
end

-- Keep sorting the table until an iteration makes no swaps
function circleSort (t)
  while innerCircle(t, 1, #t, 0) > 0 do end
end

-- Main procedure
local array = {6, 7, 8, 9, 2, 5, 3, 4, 1}
circleSort(array)
print(table.concat(array, " "))
