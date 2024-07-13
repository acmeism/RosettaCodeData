func hamming lim .
   len h[] lim
   h[1] = 1
   x2 = 2 ; x3 = 3 ; x5 = 5
   i = 1 ; j = 1 ; k = 1
   for n = 2 to lim
      h[n] = lower x2 lower x3 x5
      if x2 = h[n]
         i += 1
         x2 = 2 * h[i]
      .
      if x3 = h[n]
         j += 1
         x3 = 3 * h[j]
      .
      if x5 = h[n]
         k += 1
         x5 = 5 * h[k]
      .
   .
   return h[lim]
.
for nr = 1 to 20
   write hamming nr & " "
.
print ""
print hamming 1691
