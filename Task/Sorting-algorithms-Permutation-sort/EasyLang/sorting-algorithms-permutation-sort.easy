global perm[] .
proc nextperm . a[] .
   n = len perm[]
   k = n - 1
   while k >= 1 and perm[k + 1] <= perm[k]
      k -= 1
   .
   if k = 0
      a[] = [ ]
      return
   .
   l = n
   while perm[l] <= perm[k]
      l -= 1
   .
   swap perm[l] perm[k]
   swap a[l] a[k]
   k += 1
   while k < n
      swap perm[k] perm[n]
      swap a[k] a[n]
      k += 1
      n -= 1
   .
.
proc perminit . a[] .
   for i to len a[]
      perm[] &= i
   .
.
proc permsort . a[] .
   perminit a[]
   repeat
      for i = 2 to len a[]
         if a[i - 1] > a[i]
            break 1
         .
      .
      until i > len a[]
      nextperm a[]
      if len a[] = 0
         print "error"
         break 1
      .
   .
.
arr[] = [ 7 6 5 9 8 4 3 1 2 0 ]
permsort arr[]
print arr[]
