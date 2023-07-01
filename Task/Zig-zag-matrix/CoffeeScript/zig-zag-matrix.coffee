# Calculate a zig-zag pattern of numbers like so:
#   0 1 5
#   2 4 6
#   3 7 8
#
# There are many interesting ways to solve this; we
# try for an algebraic approach, calculating triangle
# areas, so that me minimize space requirements.

zig_zag_value = (x, y, n) ->

  upper_triangle_zig_zag = (x, y) ->
    # calculate the area of the triangle from the prior
    # diagonals
    diag = x + y
    triangle_area = diag * (diag+1) / 2
    # then add the offset along the diagonal
    if diag % 2 == 0
      triangle_area + y
    else
      triangle_area + x

  if x + y < n
    upper_triangle_zig_zag x, y
  else
    # For the bottom right part of the matrix, we essentially
    # use reflection to count backward.
    bottom_right_cell = n * n - 1
    n -= 1
    v = upper_triangle_zig_zag(n-x, n-y)
    bottom_right_cell - v

zig_zag_matrix = (n) ->
  row = (i) -> (zig_zag_value i, j, n for j in [0...n])
  (row i for i in [0...n])

do ->
  for n in [4..6]
    console.log "---- n=#{n}"
    console.log zig_zag_matrix(n)
    console.log "\n"
