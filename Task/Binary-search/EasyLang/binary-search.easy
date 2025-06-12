func binSearch &a[] val .
   low = 1
   high = len a[]
   while low <= high
      mid = (low + high) div 2
      if a[mid] > val
         high = mid - 1
      elif a[mid] < val
         low = mid + 1
      else
         return mid
      .
   .
   return 0
.
a[] = [ 2 4 6 8 9 ]
print binSearch a[] 8
