func[] numlexsort n .
   for i to n
      d[] &= i
   .
   for i = 1 to len d[] - 1
      for j = i + 1 to len d[]
         if strcmp d[j] d[i] < 0
            swap d[j] d[i]
         .
      .
   .
   return d[]
.
print numlexsort 13
