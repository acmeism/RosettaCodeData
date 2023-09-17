proc binSearch val . a[] res .
   low = 1
   high = len a[]
   res = 0
   while low <= high and res = 0
      mid = (low + high) div 2
      if a[mid] > val
         high = mid - 1
      elif a[mid] < val
         low = mid + 1
      else
         res = mid
      .
   .
.
a[] = [ 2 4 6 8 9 ]
binSearch 8 a[] r
print r
