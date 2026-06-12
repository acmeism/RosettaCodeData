proc twoSum sum &array[] &pair[] .
   i = 1
   j = len array[]
   pair[] = [ ]
   repeat
      if array[i] + array[j] = sum
         pair[] = [ i j ]
         return
      elif array[i] + array[j] > sum
         j -= 1
      elif array[i] + array[j] < sum
         i += 1
      .
      until i = j
   .
.
numbers[] = [ 0 2 11 19 90 ]
twoSum 21 numbers[] pair[]
print pair[]
