binarySearch = (xs, x) ->
  do recurse = (low = 0, high = xs.length - 1) ->
    mid = Math.floor (low + high) / 2
    switch
      when high < low then NaN
      when xs[mid] > x then recurse low, mid - 1
      when xs[mid] < x then recurse mid + 1, high
      else mid
