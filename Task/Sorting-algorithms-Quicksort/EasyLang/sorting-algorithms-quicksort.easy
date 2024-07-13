proc qsort left right . d[] .
   if left >= right
      return
   .
   mid = left
   for i = left + 1 to right
      if d[i] < d[left]
         mid += 1
         swap d[i] d[mid]
      .
   .
   swap d[left] d[mid]
   qsort left mid - 1 d[]
   qsort mid + 1 right d[]
.
proc sort . d[] .
   qsort 1 len d[] d[]
.
d[] = [ 29 4 72 44 55 26 27 77 92 5 ]
sort d[]
print d[]
