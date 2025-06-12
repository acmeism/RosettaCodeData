func qselect &list[] k .
   #
   subr partition
      mid = left
      for i = left + 1 to right
         if list[i] < list[left]
            mid += 1
            swap list[i] list[mid]
         .
      .
      swap list[left] list[mid]
   .
   left = 1
   right = len list[]
   while left < right
      partition
      if mid < k
         left = mid + 1
      elif mid > k
         right = mid - 1
      else
         left = right
      .
   .
   return list[k]
.
d[] = [ 9 8 7 6 5 0 1 2 3 4 ]
for i = 1 to len d[]
   print qselect d[] i
.
