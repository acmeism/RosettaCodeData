global list[] rlist[][] .
proc permlist k .
   if k >= len list[]
      for i to len list[]
         if i = list[i] : return
      .
      rlist[][] &= list[]
      return
   .
   for i = k to len list[]
      swap list[i] list[k]
      permlist k + 1
      swap list[k] list[i]
   .
.
#
proc derang n &r[][] .
   rlist[][] = [ ]
   list[] = [ ]
   for i to n : list[] &= i
   permlist 1
   r[][] = rlist[][]
.
r[][] = [ ]
derang 4 r[][]
print r[][]
#
func subfac n .
   if n < 2 : return 1 - n
   return (subfac (n - 1) + subfac (n - 2)) * (n - 1)
.
#
print "counted / calculated"
for n = 0 to 9
   derang n r[][]
   print n & ": " & len r[][] & " " & subfac n
.
