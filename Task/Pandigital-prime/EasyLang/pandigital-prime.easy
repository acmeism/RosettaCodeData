fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
proc nextperm &a[] &k .
   n = len a[]
   k = n - 1
   while k >= 1 and a[k + 1] > a[k] : k -= 1
   if k = 0 : return
   l = n
   while a[l] > a[k] : l -= 1
   swap a[l] a[k]
   k += 1
   while k < n
      swap a[k] a[n]
      k += 1
      n -= 1
   .
.
for ndigs in [ 7 4 ]
   digs[] = [ ]
   for i = ndigs downto 1 : digs[] &= i
   repeat
      n = 0
      for d in digs[] : n = n * 10 + d
      if isprim n = 1
         print n
         break 2
      .
      nextperm digs[] more
      until more = 0
   .
.
