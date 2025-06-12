func quickselect &list[] k .
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
func median &list[] .
   h = len list[] div 2 + 1
   r1 = quickselect list[] h
   if len list[] mod 2 = 1 : return r1
   r2 = quickselect list[] (h - 1)
   return (r1 + r2) / 2
.
test[] = [ 4.1 5.6 7.2 1.7 9.3 4.4 3.2 ]
print median test[]
test[] = [ 4.1 7.2 1.7 9.3 4.4 3.2 ]
print median test[]
