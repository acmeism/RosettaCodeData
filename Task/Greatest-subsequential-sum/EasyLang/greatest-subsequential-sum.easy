proc max_subseq &seq[] &start &stop &maxsum .
   maxsum = 0
   i = 1
   start = 1
   stop = 0
   for j to len seq[]
      sum += seq[j]
      if sum < 0
         i = j + 1
         sum = 0
      elif sum > maxsum
         start = i
         stop = j
         maxsum = sum
      .
   .
.
a[] = [ -1 -2 3 5 6 -2 -1 4 -4 2 -1 ]
max_subseq a[] a b sum
print "Max sum = " & sum
for i = a to b : write a[i] & " "
