fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
m[] = [ 1 1 ]
print 1 ; print 1
len m[] 39
arrbase m[] 0
for n = 2 to 38
   m[n] = m[n - 1]
   for i = 0 to n - 2
      m[n] += m[i] * m[n - 2 - i]
   .
   if isprim m[n] = 1
      print m[n] & " is a prime"
   else
      print m[n]
   .
.
