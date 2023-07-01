binarySearch = (xs, x) ->
  [low, high] = [0, xs.length - 1]
  while low <= high
    mid = Math.floor (low + high) / 2
    switch
      when xs[mid] > x then high = mid - 1
      when xs[mid] < x then low = mid + 1
      else return mid
  NaN
