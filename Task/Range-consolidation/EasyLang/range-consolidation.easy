proc sort . d[][] .
   n = len d[][]
   for i = 1 to n - 1
      for j = i + 1 to n
         if d[j][1] < d[i][1]
            swap d[j][] d[i][]
         .
      .
   .
.
func[][] consolidate a[][] .
   for i to len a[][]
      if a[i][1] > a[i][2]
         swap a[i][1] a[i][2]
      .
   .
   sort a[][]
   r[][] &= a[1][]
   b = a[1][2]
   for i = 2 to len a[][]
      if a[i][1] > b
         r[$][2] = b
         r[][] &= a[i][]
         b = a[i][2]
      else
         b = higher b a[i][2]
      .
   .
   r[$][2] = b
   return r[][]
.
print consolidate [ [ 1.1 2.2 ] ]
print consolidate [ [ 6.1 7.2 ] [ 7.2 8.3 ] ]
print consolidate [ [ 4 3 ] [ 2 1 ] ]
print consolidate [ [ 4 3 ] [ 2 1 ] [ -1 -2 ] [ 3.9 10 ] ]
print consolidate [ [ 1 3 ] [ -6 -1 ] [ -4 -5 ] [ 8 2 ] [ -6 -6 ] ]
