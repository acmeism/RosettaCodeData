fastfunc isprim n .
   for i = 2 to sqrt n
      if n mod i = 0 : return 0
   .
   return 1
.
len isPrime[] 64
proc .
   for i = 2 to 63
      if isprim i = 1 : isPrime[i] = 1
   .
.
global a[] .
fastfunc findRow start length .
   if length = 2
      return isPrime[a[start] + a[start + 1]]
   .
   for i = 1 step 2 to length - 2
      if isPrime[a[start] + a[start + i]] = 1
         swap a[start + i] a[start + 1]
         if findRow (start + 1) (length - 1) = 1 : return 1
         swap a[start + i] a[start + 1]
      .
   .
   return 0
.
fastfunc countRows start length .
   if length = 2
      if isPrime[a[start] + a[start + 1]] = 1 : count += 1
   else
      for i = 1 step 2 to length - 2
         if isPrime[a[start] + a[start + i]] = 1
            swap a[start + i] a[start + 1]
            count += countRows (start + 1) (length - 1)
            swap a[start + i] a[start + 1]
         .
      .
   .
   return count
.
proc printRow .
   numfmt 2 0
   for i range0 len a[]
      if i <> 0 : write " "
      write a[i]
   .
   print ""
.
for i = 2 to 20
   len a[] i
   for j range0 i : a[j] = j + 1
   if findRow 0 i = 1 : printRow
.
print ""
for i = 2 to 20
   len a[] i
   for j range0 i : a[j] = j + 1
   if i > 2 : s$ &= " "
   s$ &= countRows 0 i
.
print s$
