# This shows quicksort-in-place.
quicksort = (a) ->
  swap = (i, j) ->
    return if i == j
    [a[i], a[j]] = [a[j], a[i]]

  divide = (v, start, end) ->
    first_big = start
    j = start
    while j <= end
      if a[j] < v
        swap first_big, j
        first_big += 1
      j += 1
    first_big

  partition = (start, end) ->
    v = a[end]
    first_big = divide v, start, end-1
    swap first_big, end
    first_big

  qs = (start, end) ->
    return if start >= end
    m = partition start, end
    qs start, m-1
    qs m+1, end

  qs 0, a.length - 1

# test
do ->
  a = [1, 3, 5, 7, 9, 8, 6, 4, 2, 0, 3.5]
  quicksort(a)
  console.log a # [ 0, 1, 2, 3, 3.5, 4, 5, 6, 7, 8, 9 ]
