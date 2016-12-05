# Verify that radix_sort agrees with sort
( [1, 3, 8, 9, 0, 0, 8, 7, 1, 6],
  [170, 45, 75, 90, 2, 24, 802, 66],
  [170, 45, 75, 90, 2, 24, -802, -66] )
| (radix_sort == sort)
