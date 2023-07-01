# the trick is that at any point
# in the iteration if starting a new chain is
# better than your current score with this element
# added to it, then do so.
# the interesting part is proving the math behind it
def subarray_sum(arr)
  curr = max = 0
  first, last, curr_first = arr.size, 0, 0
  arr.each_with_index do |e, i|
    curr += e
    e > curr   && (curr = e; curr_first = i)
    curr > max && (max = curr; first = curr_first; last = i)
  end
  return max, arr[first..last]
end
